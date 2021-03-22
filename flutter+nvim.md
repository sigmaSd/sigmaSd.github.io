<style>
 body {
  background-color: #e6f497;
 }
 h1 {
  color: #021c59;
 }
 h2 {
  color:#7a3202;
 }
 p {
  font-size: 19px;
 }
 code {
  font-weight: bold;
  font-size: 16px;
 }
 .date {
  text-align: right;
  font-size: 18px;
  color: #185903;
 }
</style>

## Flutter + neovim 
<div class="date"><em>23/03/2021 9/8/1442</em></div>

Setup neovim + flutter:

______

1.  Install [vim-plug](https://github.com/junegunn/vim-plug) for managing plugins and [Coc](https://github.com/neoclide/coc.nvim) as lsp client

2. Edit neovim config
		
		call plug#begin()
		Plug 'neoclide/coc.nvim', {'branch': 'release'}
		Plug 'dart-lang/dart-vim-plugin'
		call plug#end()
		

3. Run these commands:

    - `:PlugInstall`
    - `:CocInstall coc-flutter`

***

Everything should work by default, checkout [coc-flutter](https://github.com/iamcco/coc-flutter) for the available commands.

One thing to add is formatting on save, for that run `:CocConfig` then add

`
{
    "coc.preferences.formatOnSaveFiletypes": ["dart"]
}
`
______

[Main Page](./index.html)
