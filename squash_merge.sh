#!/bin/bash

# Function to display usage instructions
usage() {
  echo "Usage: $0 <from-commit-sha> <to-commit-sha> <branch-name> <squash-commit-message>"
  exit 1
}

# Check if correct number of arguments is provided
if [ $# -lt 4 ]; then
  usage
fi

FROM_COMMIT=$1
TO_COMMIT=$2
TEMP_BRANCH=$3
SQUASH_COMMIT_MESSAGE=$4

# Get the current branch name
CURRENT_BRANCH=$(git branch --show-current)

# Create a temporary branch from the starting commit
echo "Creating temporary branch '$TEMP_BRANCH' from commit $FROM_COMMIT"
git checkout -b "$TEMP_BRANCH" "$FROM_COMMIT"

# Cherry-pick commits sequentially from $FROM_COMMIT to $TO_COMMIT
echo "Cherry-picking commits from $FROM_COMMIT to $TO_COMMIT"
git cherry-pick "$FROM_COMMIT"^.."$TO_COMMIT"

# Squash all the commits into one
echo "Squashing all the commits into one commit"
git reset --soft "$FROM_COMMIT"^
git commit -m "$SQUASH_COMMIT_MESSAGE"

# Checkout the original branch
echo "Checking out the original branch '$CURRENT_BRANCH'"
git checkout "$CURRENT_BRANCH"

# Merge the squashed commit into the original branch
echo "Merging the squashed commit into '$CURRENT_BRANCH'"
git merge --squash "$TEMP_BRANCH"
git commit -m "$SQUASH_COMMIT_MESSAGE"

# Delete the temporary branch
echo "Deleting temporary branch '$TEMP_BRANCH'"
git branch -D "$TEMP_BRANCH"

# Optionally delete the original commits from history
echo "Deleting commits from history"
git rebase --onto "$FROM_COMMIT"^ "$TO_COMMIT" "$CURRENT_BRANCH"

echo "Process completed successfully!"
