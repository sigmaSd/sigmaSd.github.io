+++
title = "Interactive usage"
date = 2021-05-05 10:00:00
+++
**23/9/1442**

The `:add` command is pretty useful, since it can be used with local crates, for example:

`:add tokio` will add tokio from crates.io\
`:add --path ./tokio` will add local crate tokio


We can use this for interactive usage:

- Create a new project to test: `cargo new --lib demo`

- `cd demo; irust `

- Now in IRust run: 

  - `:add --path .` to add current path as dependency
  - `use demo::*;`

- Now any public function written in `lib.rs` will be immediately usable in IRust after saving the file!

demo:
![Alt Text](https://github.com/sigmaSd/sigmaSd.github.io/raw/master/content/irust_book/assets/irust.gif)
