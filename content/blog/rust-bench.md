+++
title = "Inline benchmark in rust"
date = 2022-11-18 19:00:00
+++
**24/4/1444**

---

Turns out you can do inline benchmarks in rust with a not that bad user experience.
 
```sh
cargo new bench-inline
```

In `main.rs`:

```rs
#![feature(test)]

extern crate test;

fn main() {
    
}

pub fn add_two(a: i32) -> i32 {
    a + 2
}

#[cfg(test)]
mod tests {
    use super::*;
    use test::Bencher;

    #[test]
    fn it_works() {
        assert_eq!(4, add_two(2));
    }

    #[bench]
    fn bench_add_two(b: &mut Bencher) {
        b.iter(|| add_two(2));
    }
}
```

```sh
cargo +nightly bench
```


Ok so far so good, we just followed [cargo-bench](https://doc.rust-lang.org/nightly/unstable-book/library-features/test.html), we have our inline benchmarks but the problem is this: we usually want to just use stable and only use `cargo +nightly` for bench also rust analyzer gets confused with this setup.

Turns out there is a way!

1- Add a new feature lets call it nightly

`cargo.toml`
```toml
[features]
nightly = []
```

2- change our `main.rs` to:

```rs
#![cfg_attr(feature = "nightly", feature(test))]

fn main() {
    
}

pub fn add_two(a: i32) -> i32 {
    a + 2
}

#[cfg(test)]
mod tests {
    #[cfg(feature = "nightly")]
    extern crate test;

    use super::*;

    #[test]
    fn it_works() {
        assert_eq!(4, add_two(2));
    }

    #[cfg(feature = "nightly")]
    #[bench]
    fn bench_add_two(b: &mut test::Bencher) {
        b.iter(|| add_two(2));
    }
}
```

That's it! Now rust analyzer is not confused, you can run tests with `cargo test` and benchmarks with `cargo +nightly bench --features nightly`

And for a real word example I used this idea to benchmark a PR change in irust and it was really useful [irust-syntect-pr](https://github.com/sigmaSd/IRust/pull/99#issuecomment-1304842421)
