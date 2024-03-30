#!/bin/bash
directory=dist
branch=gh-pages
build_command() {
  npx webpack
}

echo -e "\033[0;32mDeleting existing $branch...\033[0m"
git push origin --delete $branch
git branch -D $branch

echo -e "\033[0;32mSetting up new $branch branch\033[0m"
git checkout --orphan $branch
git reset --hard
git commit --allow-empty -m "Initial commit"
git checkout main

echo -e "\033[0;32mDeleting old content...\033[0m"
rm -rf $directory

echo -e "\033[0;32mChecking out $branch....\033[0m"
git worktree add $directory $branch

echo -e "\033[0;32mGenerating site...\033[0m"
build_command

echo -e "\033[0;32mDeploying $branch branch...\033[0m"
cd $directory &&
  git add --all &&
  git commit -m "Deploy updates" &&
  git push origin $branch

echo -e "\033[0;32mCleaning up...\033[0m"
git worktree remove $directory
