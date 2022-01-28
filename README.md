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


### Node UID policy and drafts

1. Node UIDs should be added in order; so if the greatest node UID is `00X2`,
   then the next node that is committed should be `00X3`.

2. When a new node `00X3` is committed, it is permanent: it is not permitted to
   rename it, however it is permitted to *delete* it.

If two branches contain drafted nodes, when one is merged, the node UIDs chosen
on the other branch have to be renamed so that when *they* are committed to
`main`, there are no conflicts and node UIDs are consecutive. This causes
considerable friction, so we will use the following method for drafts.

1. In a draft, name any *new* node with an underscore `_00X3`.

2. Prior to merging, you may acquire a temporary lock on the entire repository
   and rename every node draft node to the next consecutive "permanent" UID.

The script `mint-node.rkt` will assist you in determining what the next
permanent UID is. For now you must handle the renaming manually, but in the
future we can include scripts to automate this process.
