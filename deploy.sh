#!/bin/bash

bundle exec jekyll build
./setup-worktree.sh

rm -rf _deploy/*
cp -rf _site/* _deploy/

cd _deploy
git commit -am "Deploy"
git push -u origin gh-pages
cd ..

