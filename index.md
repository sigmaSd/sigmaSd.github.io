<!--
syntax highlight
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.7.1/styles/default.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.7.1/highlight.min.js"></script>
<script>hljs.highlightAll();</script>
</head>-->

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
  font-family: 
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

# Blogging about random stuff

______
______
______


## Blogging with github pages
<div class="date"><em>23/03/2021 9/8/1442</em></div>

Github allows you to have your own site [pages.github](https://pages.github.com/)

Currently I'm using a markdown file to write the page then I can convert it to html with [python-markdown](https://python-markdown.github.io/)

`markdown_py  index.md 1>index.html`

The nice thing is the ability to add html/css code directly inside the markdown file and it will still work correctly. (useful for css styles)

Checkout this page source [sigmaSd.github.io](https://github.com/sigmaSd/sigmaSd.github.io)

______
______

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
