#!/bin/sh

# Check if there are any uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "Changes to the following files are uncommitted:"
    git diff-index --name-only HEAD --
    echo "Please commit the changes to master branch (which contains the source files of this blog) before proceeding."
    echo "Aborting."
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

echo "Deleting old publication"
rm -rf .git/worktrees/public/

echo "Make worktree"
git worktree add public gh-pages

echo "Generating site"
Rscript -e "blogdown::build_site()"

echo "Adding and committing to gh-pages branch"
cd public && git add --all && git commit -m "$1"

echo "Pushing to gh-pages branch"
git push origin gh-pages

echo "Cleaning up files"
cd ..
git worktree prune

rm -rf public
