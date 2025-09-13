+++
title = "Fun Apps With Termux"
date = 2025-09-13 07:00:00
+++
**21/3/1447**
---
Here's the problem: I want to call `"*140*1*1#"` then `"*140*00#"`. The first one registers one day of internet (the cheapest option), and most importantly, the second one disables automatic refresh of these registrations (otherwise it will keep registering each day, yeah they're annoying, they do that → totally legal shady business).

Anyhow, I asked Gemini, and it told me to add a contact with the 2 calls separated by ",". That didn't work for me. It said I could also use Tasker or something similar, but hey, I remembered Termux maybe it can do this.

And indeed it can! The plan: Termux + Termux API + Termux Widget + a script (with Deno because why not).

So here are the steps:
- Install Termux, Termux API, and Termux Widget (I use Droidify https://github.com/Droid-ify/client these days)
- Open Termux and run: `pkg upgrade && pkg install deno && pkg install termux-api`
- `mkdir -p ~/.shortcuts/tasks` (scripts under tasks run without showing Termux)
- Add the following script to `~/.shortcuts/tasks/f100.ts` (don't forget to `chmod +x`)

**f100.ts**
```ts
#!/data/data/com.termux/files/usr/bin/env -S deno -A
import {showDialog, telephonyCall} from "jsr:@sigma/termux@1"
await telephonyCall("*140*1*1#");
// Unfortunately, the telephonyCall function returns before the user actually finishes the call,
// so I added this dialog as an interruption between the two calls.
if ((await showDialog("confirm", {title:"continue?"})).text === "yes") {
  await telephonyCall("*140*00#");
}
```

The Termux lib is just a JS wrapper for Termux APIs. I generated it by giving an LLM (I don't remember which LLM I used) the Termux API repo as context. Here is the link https://jsr.io/@sigma/termux

- Now add the Termux Widget (actual widget) to the screen, then refresh. You should see the script. Click it and it should work!

<video width="640" height="360" controls>
  <source src="https://github.com/sigmaSd/sigmaSd.github.io-assets/raw/refs/heads/main/termux_app.mp4" type="video/mp4">
</video>

Termux scripts can even go beyond the APIs. How? By using ADB! You can connect Termux via ADB to your phone, and with that you can go full botting without needing a PC connection.

Here are the steps:
- In Termux: `pkg install android-tools`
- Activate wireless debugging on your phone
- Open wireless debugging settings, click on `Pair device with pairing code`
- In Termux, run `adb pair <device_ip>:<port> <code>`
- Then after pairing, run `adb connect <device_ip>:<port>` (these IP/port are different—you'll find them on the same settings page under `IP address & Port`)

That's it! Now it should work. Just one problem though: when I go to Termux to type the pairing IP, the pairing actually stops! So I don't know if there's a simpler way to do this, but I just ended up running a server inside Termux that runs shell commands from my PC so I can connect while the settings menu is open (or you can just use SSH).

Here are the scripts for reference:

**server.ts** (in termux)

```ts
// server.ts
// WARNING: This server executes any shell command it receives.
// It is highly insecure

async function handler(req: Request): Promise<Response> {
  const command = await req.text();
  console.log(`Received command: ${command}`);

  try {
    const p = new Deno.Command("bash", {
      args: ["-c", command],
      stdout: "piped",
      stderr: "piped",
    }).spawn();

    const { success } = await p.status;
    const rawOutput = await p.output();

    if (success) {
      const output = new TextDecoder().decode(rawOutput.stdout);
      return new Response(output, { status: 200 });
    } else {
      const error = new TextDecoder().decode(rawOutput.stderr);
      return new Response(error, { status: 500 });
    }
  } catch (error) {
    return new Response(`${error}`, { status: 500 });
  }
}

Deno.serve({ port: 8080 }, handler);
console.log("Server listening on http://localhost:8080");
```

**client.ts** (from pc)

```ts
// client.ts
import { createInterface } from "node:readline";
import process from "node:process";

if (Deno.args.length !== 1) {
  console.error("Usage: deno run --allow-net client.ts <server_url>");
  Deno.exit(1);
}

const serverUrl = Deno.args[0];

const rl = createInterface({
  input: process.stdin,
  output: process.stdout,
});

function readCommand() {
  rl.question("> ", async (command) => {
    if (command.toLowerCase() === "exit") {
      rl.close();
      return;
    }

    try {
      const response = await fetch(serverUrl, {
        method: "POST",
        body: command,
      });

      const result = await response.text();
      console.log(result);
    } catch (error) {
      console.error("Error sending command:", error);
    }

    readCommand();
  });
}

readCommand();
```
