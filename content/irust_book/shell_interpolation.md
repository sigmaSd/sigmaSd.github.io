+++
title = "Shell interpolation"
date = 2021-12-18 08:00:00
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
