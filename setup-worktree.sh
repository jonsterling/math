#!/bin/bash

rm -rf _site
git worktree prune
git worktree add -B gh-pages _site origin/gh-pages
