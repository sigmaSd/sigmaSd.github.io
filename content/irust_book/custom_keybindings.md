+++
title = "Custom keybindings"
date = 2021-06-02 18:00:00
+++
**21/10/1442**

Custom keybindings are possible via scripts.

Scripts come in diffrent versions in Irust, the latest version is the most supported one.

Lets see how can we add vim mode support using scripts.\
The next example uses linux commands but the same can be done on any platform.

**1 - Activate scripting feature:**
 - Edit `$config/irust/config` and set `activate_scripting3 = true` (`$config` location depends on the platform see [dirs_next](https://docs.rs/dirs-next/2.0.0/dirs_next/fn.config_dir.html))
 - Create a script directory to hold the scirpts
 `mkdir -p $config/irust/script3`

**2 - Download vim-mode script and install it**
```shell
git clone https://github.com/sigmaSd/IRust irust
cd irust/scripts_examples
cargo b --release
cp target/release/irust_vim $config/irust/script3/
```

Thats it now vim-mode can be enabled with `:vim on` command.

To see the list of the detected scripts we can use `:scripts` command.

