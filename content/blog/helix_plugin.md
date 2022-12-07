
+++
title = "Simulate plugin experience in Helix"
date = 2022-12-07 19:00:00
+++
**09/5/1444**

---

I like helix, especially multi-cursor supports which unfortunately for nvim seems hard to add

So everyone is waiting for the plugin system, till then here is a not so bad plugin like experience

- Create a folder to hold our scripts

`mkdir -p ~/dev/helix/scripts/source`

- Make helix aware of our scripts by adding scripts to the PATH only for helix

This example uses fish, other shell have similar abilities

```fish
function hx
    set PATH ~/dev/helix/scripts/ $PATH
    helix $argv
end

funcsave hx
```

So now `hx` is aliased to helix that knows about our scripts path

- Create a script

I'm going to use deno here, but any compiled program can work

The advantage of deno, is the programs have 0 permissions by default which works actually very well as a plugin

`cd ~/dev/helix/scripts`

Here is an example for a script I just needed that just simply flips `]` to `)` and `[` to `(`

`source/f.ts`

```ts
const buf = new Uint8Array(256);
const n = await Deno.stdin.read(buf);

const a = new TextDecoder().decode(buf.slice(0, n!));
let r;
switch (a) {
  case "]":
    r = ")";
    break;
  case "[":
    r = "(";
    break;
  default:
    r = a;
}
Deno.stdout.writeSync(new TextEncoder().encode(r));
```

Or another script that acts as a snippet (just inserts console.log)

```ts  
Deno.stdout.writeSync(new TextEncoder().encode("console.log("));
```

- Compile our scripts

This example uses fish syntax, other shell have similar workflow

```fish
for f in (ls source)
    deno compile source/$f
end
```

That's it, now when running helix, we can pipe a selection to our scripts using the pipe command 
which is bound to `|` key by default (can be changed, I have personally `"µ" = "shell_pipe"` for azerty keyboard)

<img src="https://cdn.discordapp.com/attachments/983096812456017934/1050122920594255882/qqqq.gif"/>
