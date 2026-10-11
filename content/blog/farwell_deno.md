+++
title = "Farewell Deno"
date = 2026-10-11
description = "A freestyle, unorganized goodbye to Deno after years of building with it, and some thoughts on what comes next."
slug = "farewell-deno"

[extra]
iine = true
iine_icon = "thumbs_up"
+++

<p dir="rtl" lang="ar">30 ربيع الآخر 1448 هـ</p>

This is a new kind of style for me where I freestyle write about my thoughts
with no care for organization or fact checking, take what I tell you next with a
grain of salt I could be misremembering or just wrong about some facts.

Disclaimer 100% AI free article, not even autocompletion , btw while we're at
it, those disclaimers where they say "disclaimer used AI" are outdated, the
default for today is written by AI article, you should only write a disclaimer
if writing the article , was not just "claude write it make no mistakes be human
no weird symbols"

EDIT: after finishing the article claude pointed out typos and fixed the zola
setup ... so not 100%

Hmm so many years passed, I think I'm one of the early users of deno, I used to
use rust on my old pc, and then I got bored of waiting for things to compile ,
and then I saw deno on rust subreddit, it looked so cool, a rust js runtime,
with some cool permissions, latest hot tech an upgrade of some old tech called
node (i never used it at the time) by the same author its like a powerup story
happening realtime for dev nerds, and ofc I jumped I didn't even know js, I read
some basic tutorials learned what map list is learned the messed up ownership
system, got annoyed there is no references no variable lifetimes no mut, how do
you even keep a mental model in this thing, (I only knew rust at that point so
all other langs were weird)

But you know I kept testing, and I immediately started liking it, the lang not
so much, where is my match , where is my enums .. But the runtime, permissions
were cool, finally a script that fetches the weather only calls the network it
doesn't need to read my ssh keys on the way and then the immediate feedback
coming from a compiled lang, was so awesome, no more compiling no more waiting
for my 10 years old i3 cpu to compile the crates, i change something and boom
its there, learning js on the server side unlocks browser (yeah i know this is
the inverse usually) and then you have access to everything, browser server
scripts compiled programs, tests inline in the script like rust with Deno.test
(and the program is guarded with import.meta.main)

Then I kept creating projects with deno not rust just because its faster and
then turns out for my profile its deno not rust that makes sense though rust is
for me a must for anyone in this field, its just beautiful it teaches you
computer fundamentals in a soft way, not in the c c++ segfault all day long and
you might learn something, this is the compiler clippy and the books the books
all kind of books that I used to read and reread, the rust book the async book
the perf book , etc (the irust book, nah never went through with the idea just
put a couple of tips and tricks) Anyhow deno makes sense because my pc is old ,
dev is not my main focus I just do it for fun so I just want apps quick
iteration fast feedback access to a gui and the browser is the best gui, i tried
most stuff gtk qt slint browser, gtk is my default if i want to make the app
gnome legit or push to flatpak (but these days they don't even accept any apps
tainted with AI so goodbye flatpak as well need a new store, unlike fdroid which
are cooler (I just happened to push my first fdroid app btw here is an fdroid
skill written by sol
<https://github.com/sigmaSd/skills/tree/main/fdroid-submit>)) but the reality
nothing compares to HTML + JS + CSS its cool you can try , you can give some
cool numbers like we have smaller size we have better perf, but you can't
(in 2026) reach browser ability to express anything and be true cross platform
at the same time, works android pc whatever day1 , you need some real os apis no
problem just bolt it to a server and whats better then Deno.serve, and this
leads us to deno desktop

## Deno desktop

Deno desktop is cool, you already know its cool because I made it header 2, I
created so many apps with it especially with AI its so convenient, and you get
apps cross platform, look on the receiver section here
<https://sigmasd.github.io/folder-camera/> easy all platforms I care about app,
I even extended it a bit to make it also build apks for android
<https://github.com/sigmaSd/denoapk> , which I use here for example
<https://github.com/sigmaSd/AI-Use> The future was cool though, deno was
planning to make itself runtime agnostic, as in it can run v8 or quickjs or
webkit, and it would compile to ios and android, and for example you can use
quickjs for smaller binaries, so many cool ideas,

Btw I used deno for all kind of stuff, like it was the carrefour for many
things,

- Deno -> js
- Deno -> python (via deno_python) useful to get python only stuff like numpy
  and matlib, but I used it mostly to access GTK (until I created the native js
  bindings)
- Wasm -> Deno you can tap in some performance from rust wasm compiled stuff, or
  use wasm as an isolated sandboxed plugin system
- Deno -> ffi give you access to the rest, anything you want dbus GTK winapis
- Deno as a server for web apps
- deno fmt to format anything
- deno works on termux so you can run deno scripts there
- deno works in flatpak and have a flatpak generator ready

and you can compile it with its bindings however complex to a single bin cross
platform, though this requires some real work to get right, nowadays its just a
prompt away

## Another header

let me list from my head the personal cool apps I like and built with deno

- <https://github.com/sigmaSd/Chef>
- <https://github.com/sigmaSd/dg>
- <https://github.com/sigmaSd/Stimulator>
- ... actually the list is too long , its just years long creating over deno,
  libraries as well
- <https://github.com/sigmaSd/jsGTK>
- ...

## Whats next

well whats running keeps running, but active projects i'm working on are
switching to something else I think node is stable opensoure cant be thrown away
since its under a foundation ? but i dont like old tech , i dont like cpp, i
dont like that there is no node fmt node check node lint node test ?

Bun then ? i didn't like it was in zig, and even said before it was rewritten ,
that "it will never beat deno because LLM excels on rust with its ownership
model and clear errors not the unstable pre 1 zig" , but then they rewrote it,
its now interesting I don't have an issue with AI slop which many have , is it
even slop if it works , no one looked at 1 million line of code, but will we
ever look at code again, maybe not now but what happens when Opus 10.10 comes ,
I think at that point your mother tongue is the only lang you need, all other
stuff are assembly as far as I care

Bun in canary have bun format bun check , its getting close to deno in what I
like for all things I care about , its missing for me Bun desktop and a
permission system , at some point i saw they were thinking about a permission
model even better then deno's like it would integrate bwrap in a way, so it
can't be bypassed by path tricks like it happened so many time with denos Btw
deno also thought of making permission model apply by import that would've been
cool, like import "./a.ts" with {perm: {read: true}}

What about rust, I don't have a slow pc anymore, but compiling is compiling, I
got used to instantaneous feedback and access to the browser ecosystem, btw this
access to the browser teaches you hacking 101 and that gets you bounties, and
that's what I did and I got a couple of bounties via "Vibe hunting" but I guess
that can be a post on its own

Another idea I thought of , is to transpile rust to js, you can imagine how nice
is to use match and ? and enums and have an ownership model, I plan to do it god
willing, though not a priority at all, everything is possible these days , I
just imagine ideas and bam they become real, your ideas are now the limit , not
your design skill , not what lang you know, not even what you studied

```rust
import "./a.ts" // hmm i guess these need to stay as is , so it can't be rust exactly
let weather = fetch("api");
match weather {
 Ok(w) => {
  println!("{}",w.temp);
  Deno.write_text_file_sync("loc.txt", JSON.stringify(w.loc)?)?;
  }
  Err(_) => println!("no weather for you , just go look out of the window");
}
```

Anyhow its a post about saying goodbye to Deno but I used this to try freestyle
writing about random subjects , atleast I gave it more worth then its
maintainers who dismissed it in one line in an announcement of an acquihire, you
would think that we would get some cool farewell blog post but no, one line is
all we get and that's why this post exist (no offense to the maintainers, good
luck to them in their future work, they were always friendly and helpful)

So so far 169 lines (i'm just counting which line I'm on in Zed) of free style I
wonder if this is interesting to read, or it should be the last of its kind,
I'll ask claude to add a thumb up counter in the page, so you can press it if
you think you want more stuff like this, and if you don't ofc there is the thumb
up as well

Farewell Deno, don't be attached to tech folks, thanks for the maintainers and
their awesome works through out the years and its great that they survived in
this AI shifting world, I'm curious whats going to be my default , or I could
just wait for Opus 10.10 to create me a js runtime with all features under the
sun
