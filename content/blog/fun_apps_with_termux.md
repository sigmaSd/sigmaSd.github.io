+++
title = "Fun Apps With Termux"
date = 2025-09-13 07:00:00
+++
**21/3/1447**

---

Here is the problem, I want to call "*140*1*1#"  then "*140*00#. The first one to register one day internet (the cheapest one) and most importantly the second one is to disable automatic refreh of this registrations (it will keep registring each day, yeah they're annoying they do that, -> top legal shady busniss)

Anyhow I asked gemini, it told me to add a contant with the 2 calls sperated with "," that didnt work for me, its said I can also use tasker or something similar, but hey I remembered termux maybe it can do this.


And indeed it can the plan: termux + termux api + termux widget + a script (with deno cause why not)

So here are the steps:

- Install termux,termux api,termux widget (I use droidify https://github.com/Droid-ify/client these days)
- mkdir -p ~/.shortcuts/tasks (scripts under tasks run without showing termux)
- add the next script to ~/.shortcuts/tasks/f100.ts (don't forget to chmod +x)

f100.ts
```ts
#!/data/data/com.termux/files/usr/bin/env -S deno -A
import {showDialog, telephonyCall} from "jsr:@sigma/termux@1"

await telephonyCall("*140*1*1#");
if ((await showDialog("confirm", {title:"continue?"})).text === "yes") {
  await telephonyCall("*140*00#");
}
```

The termux lib is just a js wrapper for termux apis, I generated it by giving the LLM (I don't rememeber which LLM I used) the termux api repo as context.

- Now add termux widget (actual widget) to the screen, then refresh, you should see the script, click it and it should work

Gif placeholder
