#!/bin/bash

rm -rf _deploy
git worktree prune
git worktree add -B gh-pages _deploy origin/gh-pages
