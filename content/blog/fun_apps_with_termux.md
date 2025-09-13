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

The Termux lib is just a JS wrapper for Termux APIs. I generated it by giving an LLM (I don't remember which LLM I used) the Termux API repo as context.

- Now add the Termux Widget (actual widget) to the screen, then refresh. You should see the script. Click it and it should work!

*Gif placeholder*
