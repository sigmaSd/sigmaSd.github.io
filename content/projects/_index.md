+++
# The websites of my projects, published from their own repositories (except IRust's: its book, in this one).
#
# Each project site owns /<repo>/ on this domain, so no page, section or static folder of the blog may use
# a project's name at the root: not content/tandem/, static/tandem/ or a page with path = "tandem".
#
# New project site: add it below, with its icon in static/projects/ and an 880x550 screenshot
# (sample data) in static/projects/screenshots/. Its tags are the systems it runs on.
title = "Projects"
template = "projects.html"

[[extra.projects]]
name = "Tandem"
description = "Keeps folders the same on your computers and phones, over your local network."
url = "https://sigmasd.github.io/tandem/"
icon = "projects/tandem.png"
screenshot = "projects/screenshots/tandem.webp"
tags = ["Linux", "Windows", "macOS", "Android"]

[[extra.projects]]
name = "Folder Camera"
description = "An Android camera that saves photos straight into the folders you choose."
url = "https://sigmasd.github.io/folder-camera/"
icon = "projects/folder-camera.png"
screenshot = "projects/screenshots/folder-camera.webp"
tags = ["Android"]

[[extra.projects]]
name = "Inktyset"
description = "Turns handwritten pages, math first, into a typeset LaTeX or Typst document, on your own computer."
url = "https://sigmasd.github.io/inktyset/"
icon = "projects/inktyset.svg"
screenshot = "projects/screenshots/inktyset.webp"
tags = ["Linux", "Windows", "macOS"]

[[extra.projects]]
name = "Bandito"
description = "Shows how much each app downloads and uploads, and limits any of them."
url = "https://sigmasd.github.io/bandito-gtk/"
icon = "projects/bandito.svg"
screenshot = "projects/screenshots/bandito.webp"
tags = ["Linux"]

[[extra.projects]]
name = "IRust"
description = "A Rust REPL for the terminal: type Rust and see what it does. Opens its book."
url = "/irust_book/"
icon = "projects/irust.png"
screenshot = "projects/screenshots/irust.webp"
tags = ["Linux", "Windows", "macOS"]
+++
