+++
title = "Download messenger images"
date = 2024-05-26 12:00:00
+++
**18/11/1445**

---
Turns out when someone send you a bunch of pictures in facebook, there is no way
to download them at once.

![bunch of pictures](https://github.com/sigmaSd/sigmaSd.github.io/assets/22427111/b9cecd5f-11ca-488d-aae1-1b5a6034fff3)


So here is what I tried in order to download them all (the working method is
last, so you can skip to it if you want)

In all the next methods the idea is simple: automate the next steps

- click on the download button
- click on the next button

![download Interface](https://github.com/sigmaSd/sigmaSd.github.io/assets/22427111/3debebd4-a77b-4def-8ab5-fbb99a74d106)


# Javascript injection

- Right click on the button we need (the download button, then the next button)
- Click inspect
- Right click on the dom element in the inspector
- Copy -> Css selector
- Go to the console
- Type: `document.querySelector('<your css selector>').click()`

This works initially, but soon the page freezes and I get this error on the
console: `ErrorUtils caught an error:  too much recursion`

Maybe its a facebook security protection.

I also tried sending right arrow keyboard click as an alternative but the same
error happens.

Here is the code in case you're interested (I just asked chatgpt for it)

```js
(function () {
  // Create the event
  var rightArrowEvent = new KeyboardEvent("keydown", {
    key: "ArrowRight",
    code: "ArrowRight",
    keyCode: 39, // The keyCode for the right arrow key
    which: 39, // The same value as keyCode
    shiftKey: false, // No shift key
    ctrlKey: false, // No ctrl key
    metaKey: false, // No meta key
    altKey: false, // No alt key
    bubbles: true, // Bubbles up through the DOM
    cancelable: true, // The event can be canceled
  });

  // Dispatch the event to the target element or document
  document.dispatchEvent(rightArrowEvent);
})();
```

So this didn't work time to go to next idea

# Ydotool

Javascirpt injection didn't work, so the next idea that came to mind is to use
good old botting.

I'm using wayland so there is no xdotool here, but you can use
[ydotool](https://github.com/ReimuNotMoe/ydotool).

Its even already available in fedora official packages.

**The steps are:**

- `sudo dnf install ydotool`
- `sudo ydotoold& # so it runs in the background`
- `sudo ydotool <commands here>`

Unfortunately it works partially, in particular
`ydotool mousemove --absolute -x $xpos -y $ypos` only moves the x in my testing,
the mouse is always stuck on the top.

## Xdotool

So whats left, of course the battle tested [xdotool](https://github.com/jordansissel/xdotool), the good thing is fedora
still have gnome on xorg installed by default, so I can simply logout and switch to
it to be able to use xdotool.

**The steps are:**

- make sure your on xorg
- `sudo dnf install xdotool`
- put the mouse on the exact location of the download button
- `xdotool getmouselocation #note the location somewhere`
- put the mouse on the exact location of the next button
- `xdotool getmouselocation #note the location somewhere`
- and now simply we click on the buttons on a loop

```fish
sleep 0.5 # wait for me to tab switch to the page;
while true
    xdotool mousemove 1075 178 # move to download button position
    xdotool click 1 # mouse left click
    sleep 2
    xdotool mousemove 1328 431 # move to next button position
    xdotool click 1 # mouse left click
    sleep 0.1
end
```

And that actually works, In a couple of seconds I have downloaded all the
pictures sent to me.
