+++
title = "Use the clouds (gitpod)"
date = 2021-03-24 18:00:00
+++
**11/8/1442**

---
Recently I discovered [gitpod](https://gitpod.io/) and its been great!

You get access to a super environment for free.

Ever thought about contributing to a cool project, but building it requires waiting a couple of hours? gitpod might be what you're looking for.

Its as simple as adding `gitpod.io/#` infront of the repository url, and you immediately get access to a powerful environment.\
Example: `https://gitpod.io/#https://github.com/sigmaSd/visual-studio-code-wayland`\

I even have a script (invoked by a launcher) that runs `wl-copy "gitpod.io/#"`
Obviously you can just use the browser extension.


Currently I'm using gitpod to build an android apk from a flutter project [https://github.com/sigmaSd/APOD/tree/gitpod](https://github.com/sigmaSd/APOD/tree/gitpod) (success!) and also building vscode with wayland support (success!(checkout *update1*)).


Couple of tips and tricks:
-  To be able to use `sudo` (which is really handy for installing dependencies without messing with the docker image) you can go to  [https://gitpod.io/settings/](https://gitpod.io/settings/) and enable `Feature Preview` and that's it now you can!

- Do *not* use the vscode vim extension, currently it makes everything slow, but that might change soon! [https://github.com/gitpod-io/gitpod/issues/1212](https://github.com/gitpod-io/gitpod/issues/1212)

- Building an android apk is a little bit tricky, I wrote a simple guide here [https://github.com/sigmaSd/flutter_gitpod](https://github.com/sigmaSd/flutter_gitpod)

- Downloading a file from gitpod sometimes freeze the ui.\
Using `python -m http.server` seems to work better.


*Update1:* To build vscode with wayland support here are the steps [https://github.com/microsoft/vscode/issues/109176#issuecomment-806067083](https://github.com/microsoft/vscode/issues/109176#issuecomment-806067083)
