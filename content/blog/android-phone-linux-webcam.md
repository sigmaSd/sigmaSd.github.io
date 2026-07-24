+++
title = "Turn Your Android Phone into a Linux Virtual Webcam (No Third-Party Apps, Secure Boot Friendly)"
date = 2026-07-25
description = "Using native Android camera features via scrcpy, v4l2loopback, and a short Bash script to build a scriptable, headless, local wireless webcam setup on Linux."
+++

You don't need any third-party Android apps installed on your phone to get a clean 1080p stream into `/dev/video0`. Using native Android camera features via `scrcpy`, `v4l2loopback`, and a short Bash script, you can build a scriptable, headless, local wireless webcam setup on Linux—even with **Secure Boot** enabled.

---

## The Tech Stack

1. **ADB over Wi-Fi**: Native Android developer tooling for wireless frame capture.
2. **`v4l2loopback`**: The Linux kernel module that creates virtual video devices (`/dev/videoX`).
3. **`sign-file` + MOK**: Signs the compiled kernel module so Secure Boot allows `insmod`.
4. **`scrcpy` + Zenity**: Grabs the camera feed and presents a quick desktop dialog to choose between front and back sensors on launch.

---

## Step 1: Clone `v4l2loopback`

First, clone the official repository to a local directory:

```bash
git clone https://github.com/umlaeute/v4l2loopback.git ~/dev/others/v4l2loopback
cd ~/dev/others/v4l2loopback

```

---

## Step 2: One-Time Key Generation & MOK Enrollment (Secure Boot)

If Secure Boot is active on your system, loading an unsigned kernel module (`insmod v4l2loopback.ko`) will fail. To fix this, create a local keypair and register it with UEFI using `mokutil`.

### 1. Generate the Certificate & Private Key

Inside your `v4l2loopback` folder, run:

```bash
openssl req -new -x509 -newkey rsa:2048 \
    -keyout MOK.key -outform DER -out MOK.crt \
    -nodes -days 36500 -subj "/CN=Local Module Signing Key/"

```

Here is what each flag actually does under the hood:

* `-new -x509`: Instructs OpenSSL to output a self-signed X.509 public key certificate rather than a Certificate Signing Request (CSR).
* `-newkey rsa:2048`: Generates a new 2048-bit RSA keypair simultaneously.
* `-keyout MOK.key`: Specifies where to save the **private key** (used later by `sign-file` to sign `.ko` modules).
* `-outform DER`: Formats the public certificate as binary DER data (required by Linux kernel/UEFI tools) instead of the default Base64 PEM format.
* `-out MOK.crt`: Specifies where to save the **public certificate** (imported into the UEFI MOK database).
* `-nodes`: Short for "no DES"—stores the private key unencrypted so automated build scripts can sign modules without prompting for a passphrase.
* `-days 36500`: Sets key validity to ~100 years so you don't have to re-enroll keys every few months.
* `-subj "/CN=..."`: Fills in the Common Name field directly, bypassing the interactive country/organization prompts.

### 2. Enroll the Key into the UEFI Database

```bash
sudo mokutil --import MOK.crt

```

*Reboot your system. You will see a blue UEFI screen prompting you to **Enroll MOK**. Select it, enter the temporary password you set during `--import`, and boot into Linux.*

---

## Step 3: Connect via Wireless ADB (Zero Setup via `adb-wifi`)

Instead of manually checking IP addresses, pairing ports, and running `adb pair` / `adb connect` every time, you can automate wireless pairing using QR codes via [adb-wifi](https://github.com/sigmaSd/adb-wifi). It uses mDNS to discover your device automatically.

Run it directly via Deno without installing anything:

```bash
deno -NS --unstable-net --allow-run=adb https://raw.githubusercontent.com/sigmaSd/adb-wifi/refs/heads/master/main.ts

```

1. Go to **Settings → Developer options → Wireless debugging** on your phone.
2. Select **Pair device with QR code**.
3. Scan the terminal QR code. Once paired, your host machine maintains an active ADB connection over Wi-Fi.

---

## Step 4: Automate Everything with Bash + Zenity

The script below handles kernel compilation, signs the `.ko` file against your MOK key, loads the drivers, queries available phone cameras using `scrcpy`, and pops up a **Zenity GUI dialog** to let you pick the front or rear camera on launch.

Save this as `phone-webcam.sh` and make it executable (`chmod +x phone-webcam.sh`):

```bash
#!/usr/bin/env bash
set -euo pipefail

# === CONFIGURATION ===
SRC_DIR="$HOME/dev/others/v4l2loopback" # Folder containing the v4l2loopback Makefile/C source
MOK_KEY="$SRC_DIR/MOK.key"
MOK_CRT="$SRC_DIR/MOK.crt"
KO_PATH="$SRC_DIR/v4l2loopback.ko"
VIDEO_DEV="/dev/video0"
CUR_KVER="$(uname -r)"

echo "=== Starting Wireless Phone Webcam Pipeline ==="

# 1. Verify ADB is connected
echo "[1/5] Checking ADB connection..."
if ! adb devices | grep -qE '\bdevice\b'; then
    echo "ERROR: No active ADB device found." >&2
    echo "Please connect via Wireless ADB (adb connect <IP>:<PORT>) and re-run." >&2
    exit 1
fi

# 2. Check if we need to auto-compile for the current kernel
# Recompiles if .ko is missing OR if kernel headers/build tree path changed
if [[ ! -f "$KO_PATH" ]] || ! modinfo "$KO_PATH" | grep -q "$CUR_KVER"; then
    echo "[2/5] Kernel update or missing module detected ($CUR_KVER). Compiling v4l2loopback..."
    
    # Ensure kernel development headers are installed for current running kernel
    if [[ ! -d "/lib/modules/$CUR_KVER/build" ]]; then
        echo "Installing missing kernel-devel package for $CUR_KVER..."
        sudo dnf install -y "kernel-devel-$CUR_KVER"
    fi

    # Build the module in source directory
    make -C "$SRC_DIR" clean
    make -C "$SRC_DIR" -C "/lib/modules/$CUR_KVER/build" M="$SRC_DIR" modules

    echo "Signing compiled module..."
    sudo /usr/src/kernels/"$CUR_KVER"/scripts/sign-file \
        sha256 \
        "$MOK_KEY" \
        "$MOK_CRT" \
        "$KO_PATH"
else
    echo "[2/5] Module $KO_PATH is up to date for kernel $CUR_KVER."
fi

# 3. Ensure base videodev kernel subsystem is active
echo "[3/5] Ensuring videodev kernel module is active..."
if [[ ! -d /sys/module/videodev ]]; then
    sudo modprobe videodev
fi

# 4. Insert v4l2loopback if not already loaded in kernel memory
if [[ ! -d /sys/module/v4l2loopback ]]; then
    echo "[4/5] Inserting v4l2loopback module..."
    sudo insmod "$KO_PATH" exclusive_caps=1 card_label="Phone Webcam"
else
    echo "[4/5] v4l2loopback is already loaded."
fi

# 5. Let user pick camera source via Zenity GUI
echo "[5/5] Selecting camera source..."
CAMERAS=$(scrcpy --list-cameras 2>/dev/null)
FRONT_ID=$(echo "$CAMERAS" | grep -i 'front' | grep -oP 'camera-id=\K\d+')
BACK_ID=$(echo "$CAMERAS" | grep -i 'back' | grep -oP 'camera-id=\K\d+')

CHOICE=$(zenity --list --title="Phone Webcam" --text="Choose camera source:" \
    --column="Camera" \
    "Front" \
    "Back" \
    2>/dev/null) || exit 1

case "$CHOICE" in
    Front) CAMERA_CHOICE="$FRONT_ID" ;;
    Back)  CAMERA_CHOICE="$BACK_ID" ;;
esac

# 6. Launch headless scrcpy stream directly to virtual webcam node
echo "[6/5] Streaming camera feed to ${VIDEO_DEV}..."
scrcpy --video-source=camera \
       --camera-id="$CAMERA_CHOICE" \
       --camera-size=1920x1080 \
       --camera-fps=30 \
       --v4l2-sink="${VIDEO_DEV}" \
       --no-video-playback \
       --no-audio

```

---

## Usage Workflow

1. Connect your device via ADB Wi-Fi:
```bash
deno -NS --unstable-net --allow-run=adb https://raw.githubusercontent.com/sigmaSd/adb-wifi/refs/heads/master/main.ts

```


2. Execute your script:
```bash
./phone-webcam.sh

```


3. A native GTK dialog pops up allowing you to pick **Front** or **Back**. Once selected, `scrcpy` binds to `/dev/video0` with zero display overhead or window latency!

Now that `v4l2loopback` presents `/dev/video0` as a standard V4L2 device node (and loaded with `exclusive_caps=1`), your phone functions like a regular hardware webcam across your entire system. You can immediately open Chrome, Firefox, Zoom, OBS Studio, Discord, or Teams, select **"Phone Webcam"** from your video device list, and enjoy an uncompressed 1080p stream.

---

## A Note on Camera Resolutions (`--camera-size`)

The `--camera-size=1920x1080` parameter tells `scrcpy` which resolution mode to request from the Android Camera2 API.

- **Explicit Resolutions**: `scrcpy` will only accept resolutions actually exposed by your phone's camera hardware. Standard choices include `1920x1080` (1080p), `1280x720` (720p), or `3840x2160` (4K).
- **Listing Supported Sizes**: If `1920x1080` fails or looks stretched, you can list every native size supported by your phone's sensors by running:

```bash
scrcpy --list-camera-sizes
```

- **Auto-Scaling**: If you pass a maximum dimension constraint like `--max-size=1920` (or `-m1920`) instead, `scrcpy` automatically picks the best matching native resolution for the selected camera sensor.
