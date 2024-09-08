#!/bin/bash

# Check if correct number of arguments is provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <commit-sha> <new-message> [new-author]"
  exit 1
fi

COMMIT_SHA=$1
NEW_MESSAGE=$2
NEW_AUTHOR=$3

# Stash any uncommitted changes to make sure the working directory is clean
git stash --quiet

# Start an interactive rebase, starting at the parent of the commit
git rebase -i --rebase-merges --autosquash $COMMIT_SHA^

# In the rebase file, we will search for the commit to change and mark it for editing
# Automatically edit the commit you want to change
sed -i "s/^pick $COMMIT_SHA/edit $COMMIT_SHA/" .git/rebase-merge/git-rebase-todo

# Continue the rebase process
git rebase --continue

# Amend the commit with the new message
if [ -n "$NEW_AUTHOR" ]; then
  git commit --amend --author="$NEW_AUTHOR" -m "$NEW_MESSAGE"
else
  git commit --amend -m "$NEW_MESSAGE"
fi

# Continue the rebase to apply any other commits on top of this one
git rebase --continue

# Apply any stashed changes back
git stash pop --quiet

echo "Commit $COMMIT_SHA has been successfully updated."
