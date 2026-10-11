# Theme maintenance

The site uses [tabi](https://github.com/welpo/tabi), vendored as a plain folder
in `themes/tabi` (not a submodule). It is kept **identical to an upstream
release**, so updating it is just copying the new version over it.

Current version: **tabi v5.0.0** (requires Zola >= 0.23.6).

## Rule: never edit `themes/tabi`

Put site-specific changes outside the theme:

- **CSS tweaks** go in `static/custom.css`. It's loaded after the theme's CSS via
  `stylesheets = ["custom.css"]` in `config.toml`.
- **Template overrides** go in `templates/` at the site root, using the same
  path as the theme file (Zola prefers the site's copy). Note any here.
- **Settings** go in `config.toml` `[extra]` or in a page's front matter `[extra]`.
  See `themes/tabi/config.toml` for all options.

### Current customisations

| What | Where |
| --- | --- |
| Inline `code` styled as a bordered chip (border, `--bg-0` background, 0.85rem) | `static/custom.css` |

## Updating tabi

```bash
git clone https://github.com/welpo/tabi ~/dev/tmp/tabi
git -C ~/dev/tmp/tabi checkout vX.Y.Z   # latest tag
rsync -a --delete --exclude=.git ~/dev/tmp/tabi/ themes/tabi/
chef run zola build -o ~/dev/tmp/zola-out --force
chef run zola serve
```

Then:

1. Read the tabi `CHANGELOG.md` for breaking changes and the minimum Zola
   version (`min_version` in `themes/tabi/theme.toml`).
2. Make sure CI ships at least that Zola: the version is set by
   `shalzz/zola-deploy-action` in `.github/workflows/main.yml`. Check the Zola
   download URL in that action's `Dockerfile` for the tag/commit you pin.
3. Check that the customisations above still look right.

## Gotchas

- Since Zola 0.23, `{{ ... }}` / `{% ... %}` in post markdown are parsed as
  templates and break the build. Wrap literal examples in
  `{% raw %}...{% endraw %}` (see `content/blog/githubPages2.md`).
