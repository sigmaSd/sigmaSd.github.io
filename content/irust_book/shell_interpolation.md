+++
title = "Shell interpolation"
date = 2021-05-05 10:00:00
weight = 20
description = "Execute shell commands directly from IRust with interpolation support."
+++

**14/05/1443**

I recently noticed that IPython can interpolate shell, which I thought is pretty useful so I added it to IRust.

You can still invoke the shell via `::` like `::ls`

But now you can also interpolate shell via `$$shell here$$`, example:

```rust
let list = $$ ls -la $$;
:type list // This outputs `String`
```

This will transform the result of the shell result to a String, that you can simply use!

demo:
![Alt Text](https://github.com/sigmaSd/sigmaSd.github.io/raw/master/content/irust_book/assets/aoc_2021.gif)
