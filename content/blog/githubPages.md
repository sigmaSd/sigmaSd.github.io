+++
title = "Github Pages"
date = 2021-03-22 11:00:00
+++
**9/8/1942**

---

Github allows you to have your own page [pages.github](https://pages.github.com/)

<br/>

Currently I'm using a markdown file to write the page then I can convert it to html with [python-markdown](https://python-markdown.github.io/)

`markdown_py  index.md 1>index.html`

<br/>

The nice thing is the ability to add html/css code directly inside the markdown file and it will still work correctly. (useful for css styles)

<br/>

Checkout this page source code [sigmaSd.github.io](https://github.com/sigmaSd/sigmaSd.github.io)

<br/>

*Update1*: Now that I use multiple pages, the new command is (*fish sell*):

```fish
for i in (ls | rg '\.md')
	set h (echo $i | sd '..$' 'html'); markdown_py $i 1>$h;
end
```

*Update2*: The up-to-date command is located here [compile.fish](https://github.com/sigmaSd/sigmaSd.github.io/blob/simple_html%2Bcss/compile.fish)

*Update3*: This page now uses [zola](https://www.getzola.org/). To see the old method blogged about in this post, checkout this link [old_page](https://github.com/sigmaSd/sigmaSd.github.io/tree/simple_html+css) (html/css branch)
