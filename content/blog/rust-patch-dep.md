+++
title = "Patch rust dependency"
date = 2022-11-19 19:00:00
+++
**25/4/1444**

---

Say we want to debug a dependency of a project, lets make a quick fixture.

```sh
cargo new patchit
```

```sh
cargo add regex
```

We can see our dependencies with:

```sh
cargo tree
```

```
patchit v0.1.0
└── regex v1.7.0
    ├── aho-corasick v0.7.19
    │   └── memchr v2.5.0 // lets patch this one
    ├── memchr v2.5.0 // which means also this one
    └── regex-syntax v0.6.28
```

Ok say we want to debug `memchr`:

First we need to get its source, either download it from github or more easily run:

```sh
cargo vendor
```

This will download all dependencies under `vendor` folder, and it will recommend to replace `crates-io` sources under `config.toml` but we're only interested in the downloading part.

And we're only interested in debugging one dependency, we can simply do this by adding this to `cargo.toml`:

```toml
[patch.crates-io]
memchr = { path = "vendor/memchr" }
```

That's it! Now you can modify `vendor/memchr` sources and it will be automatically picked up.

