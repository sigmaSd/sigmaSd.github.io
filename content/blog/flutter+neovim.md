+++
title = "Flutter + NeoVim"
date = 2021-03-22 10:00:00
+++
**9/8/1442**

---

**Setup neovim + flutter:**
1.  Install [vim-plug](https://github.com/junegunn/vim-plug) for managing plugins and [Coc](https://github.com/neoclide/coc.nvim) as lsp client

2. Edit neovim config

```
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dart-lang/dart-vim-plugin'
call plug#end()
```

3. Run these commands:

    - `:PlugInstall`
    - `:CocInstall coc-flutter`


Everything should work by default, checkout [coc-flutter](https://github.com/iamcco/coc-flutter) for the available commands.

Most frequent commands:
- `:CocCommand flutter.run`
- `:CocCommand flutter.dev.openDevLog`
- `:CocCommand flutter.dev.hotRestart`

One thing to add is formatting on save, for that run `:CocConfig` then add

`
{
    "coc.preferences.formatOnSaveFiletypes": ["dart"]
}
`
