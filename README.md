This repository is based on [Krater](https://github.com/paolobrasolin/krater),
a tool for building math-rich websites; the purpose of the present code is to
support "Stacks Project"-style websites, where you create a bunch of files like
`_nodes/00A4.md` that may import each other, and then specify a root like
`_lectures/lecture.md` that imports some node.

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

