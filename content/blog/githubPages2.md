+++
title = "Github Pages (Part 2)"
date = 2021-03-22 17:00:00
+++
# ***9/8/1942***
---

This page now uses [zola](https://www.getzola.org/).

<br/>

It was pretty straight forward to set up, simply following [getting-started](https://www.getzola.org/documentation/getting-started/overview/)
should get you up and running.

<br/>

*Couple of things I had to look for:*

- **Formatting dates:** 

`{{ page.date | date(format=$chrono_format_string) }}` example: `{{ page.date | date(format="%D") }}`


- **Using the correct relative url in the template:**

`{ get_url(path=$path)}` example: `{ get_url(path="/")}`

- **Adding new lines in markdown:**

`<br/>`
