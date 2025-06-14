#!/bin/sh

rm .hugo_build.lock

if [ "`git status -s`" ]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

DEPLOY_BRANCH="${DEPLOY_BRANCH:-pages}"

echo "Checking out ${DEPLOY_BRANCH} branch into public"
git worktree add -B ${DEPLOY_BRANCH} public origin/${DEPLOY_BRANCH}

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo --ignoreCache

#mkdir -p public/.github/workflows
#cp -v .github/workflows/deploy.yaml public/.github/workflows/
cp -v CNAME public/CNAME

echo "Updating ${DEPLOY_BRANCH} branch"
cd public && git add --all && git commit -m "Publishing to pages (publish.sh)"

#echo "Pushing to github"
#git push --all
