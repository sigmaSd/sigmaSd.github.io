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
  font-style: italic;
 }
 .date {
  text-align: right;
  font-size: 18px;
  color: #185903;
 }
</style>

## Blogging with github pages

Github allows you to have your own site [pages.github](https://pages.github.com/)

Currently I'm using a markdown file to write the page then I can convert it to html with [python-markdown](https://python-markdown.github.io/)

`markdown_py  index.md 1>index.html`

The nice thing is the ability to add html/css code directly inside the markdown file and it will still work correctly. (useful for css styles)

Checkout this page source [sigmaSd.github.io](https://github.com/sigmaSd/sigmaSd.github.io)


*Edit*: Now that I use multiple pages, the new command is (*fish sell*):

		for i in (ls | rg '\.md')
				set h (echo $i | sd '..$' 'html'); markdown_py $i 1>$h;
		end

______

[Main Page](./index.html)
