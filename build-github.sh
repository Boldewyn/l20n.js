#!/bin/bash

# A useful build script for projects hosted on github:
# It can build your Sphinx docs and push them straight to your gh-pages branch.

if [[ -z $1 ]]; then
    REMOTE=upstream
else
    REMOTE=$1
fi

REPO=$(git config remote.$REMOTE.url)
GH=_build/gh-pages


# Checkout the gh-pages branch, if necessary.
if [[ ! -d $GH ]]; then
    git clone $REPO $GH
    pushd $GH
    git checkout -b gh-pages origin/gh-pages
    popd
fi

# Update the _gh-pages target dir.
pushd $GH
git pull
popd

# Make a clean build.
make docs
make coverage

# Move the fresh build over.
cp -r docs/* $GH
pushd $GH

# Commit.
git add .
git commit -am "gh-pages build on $(date)"
git push origin gh-pages

popd
