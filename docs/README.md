# krater

<img align="right" width="192px" alt="Terracotta calyx-krater, ca. 460–450 B.C. Source: https://www.metmuseum.org/art/collection/search/247966" src="https://github.com/paolobrasolin/krater/raw/main/krater.png">

This is a template to start building math-rich websites effortlessly.

Ancient Greeks placed large vessels named _kraters_ at the center of the room during a symposium.
An elected _symposiarch_ would oversee the event by deciding the dilution of the wine in the krater and timing refills.
Meanwhile, other _symposyasts_ drank, talked, and enjoyed any pleasure the evening offered.

I hope this affords you to reproduce that, with ideas instead of wine.

## Getting started

1. Click [`Use this template`][krater-generate-url] here or at the top of this page.
2. Pick a name for your new repo and create it.
3. Edit `_config.yml` replacing `krater` with your repo name in `baseurl` and `paolobrasolin` with your user name in `url`.
4. Wait for the first build to become green; you can observe its status at `> Actions > Publish`.
5. Enable GitHub Pages on branch `gh-pages` and folder `/`; you can reach the configuration panel at `> Settings > Pages`.

That's it! Your website is now visible at `https://<USER_NAME>.github.io/<REPO_NAME>/`

[krater-generate-url]: https://github.com/paolobrasolin/krater/generate

## Usage

This is a [Jekyll][jekyll-url] setup, so its excellent documentation fully applies.

Schematically, this is what `krater` gives you:

- A [KaTeX][katex-url] setup composed of:
  - a custom page header in `custom-head.html`
  - a default configuration at `katex` in `_config.yml`
- An [AnTeX][antex-url] setup composed of:
  - the [`jekyll-antex`][jekyll-antex-url] gem in `Gemfile`
  - a default configuration at `antex` in `_config.yml`
- A tweak to the `kramdown` configuration in `_config.yml` to let the previous components do their job.
- A [GitHub Action][gha-url] workflow which compiles and publishes your website on [GitHub Pages][ghp-url] everytime something is pushed to the `main` branch.

As long as you keep these pieces in place the math rendering machinery will work.

Let's review some common tasks now.

[jekyll-url]: https://jekyllrb.com/
[katex-url]: https://katex.org/
[antex-url]: https://github.com/paolobrasolin/antex/
[jekyll-antex-url]: https://github.com/paolobrasolin/jekyll-antex/
[gha-url]: https://github.com/features/actions
[ghp-url]: https://pages.github.com/

### Running on your machine

You will need a running LaTeX installation, including `latexmk`, `dvisvgm` and whatever engine and packages you plan on using.
Chances are that if you're reading this you already have everything you need.

You will need to [install Ruby][ruby-install-url].

After that, you can simply

```bash
# install dependencies
bundle
# run Jekyll
bundle exec jekyll serve
```

and your website will be available at `http://127.0.0.1:4000/<REPO_NAME>/`.

[ruby-install-url]: https://www.ruby-lang.org/it/documentation/installation/

### Configuring CI

The CI workflow uses [this action][setup-texlive-action-url] to setup TeX Live.
If you require some less than common packages, just add them to the list in `.github/texlive.packages` and push to the repo.
You can also change the scheme in `.github/texlive.profile` but I strongly advice against that if you're not sure what you're doing.

[setup-texlive-action-url]: https://github.com/paolobrasolin/setup-texlive-action

### Kickstarting a blog/course/book

If you're familiar with Jekyll, you can proceed as usual.
If you're not, all common tutorials apply.

If there's interest in some examples or a more specific template, HMU!

### Plugins customization

`krater` installs [all Jekyll plugins available in GitHub Pages][ghp-jekyll-plugins-url] via the `github-pages` gem in the `Gemfile`.
This will help you if you're used to the standard features of GitHub Pages.

If you wish, you can be more selective and cherry pick only the plugins you need.

You can also any other [Jekyll plugins][jekyll-plugins-url] you need: the build process runs in custom CI action and the usual limitations of GitHub Pages do not apply.

[ghp-jekyll-plugins-url]: https://pages.github.com/versions/
[jekyll-plugins-url]: https://jekyllrb.com/docs/plugins/

### Theme customization

The default theme is [`minima`][minima-url] but you can easily change that as long as you ensure `custom-head.html` still gets included.

[minima-url]: https://github.com/jekyll/minima
