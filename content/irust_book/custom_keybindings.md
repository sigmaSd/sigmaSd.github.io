+++
title = "Custom keybindings"
date = 2021-06-02 18:00:00
+++
**21/10/1442**

Custom keybindings are possible via scripts.

Lets see how can we add vim mode support using scripts.

The next example uses linux commands but the same can be done on any platform.

**1 - Activate scripting feature:**
 - Edit `$config/irust/config` and set `activate_scripting = true` (`$config` location depends on the platform see [dirs](https://docs.rs/dirs/latest/dirs/fn.config_dir.html))
 - Create a script directory to hold the scripts
 `mkdir -p $config/irust/script4`

**2 - Download vim-mode script and install it**
```shell
git clone https://github.com/sigmaSd/IRust irust
cd irust/scripts_examples
cargo b --release
chmod +x target/release/irust_vim
cp target/release/irust_vim $config/irust/script4/
```

That's it, to check for the list of scripts, run `:scripts`

To activate/deactivate a script run `:scripts $script [activate|deactivate]`

We can enable vim-mode now via `:scripts Vim activate`
