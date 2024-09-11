#!/bin/bash

# Function to display usage instructions
usage() {
  echo "Usage: $0 <from-commit-sha> <to-commit-sha> <branch-name> <squash-commit-message>"
  exit 1
}

# Check if the correct number of arguments is provided
if [ $# -lt 4 ]; then
  usage
fi

FROM_COMMIT=$1
TO_COMMIT=$2
TEMP_BRANCH=$3
SQUASH_COMMIT_MESSAGE=$4

# Ensure we are in a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Error: This is not a valid Git repository."
  exit 1
fi

# Get the current branch name
CURRENT_BRANCH=$(git branch --show-current)

# Get the date of the to-commit-sha
TO_COMMIT_DATE=$(git show -s --format=%ci "$TO_COMMIT")

# Create a temporary branch from the starting commit
echo "Creating temporary branch '$TEMP_BRANCH' from commit $FROM_COMMIT"
git checkout -b "$TEMP_BRANCH" "$FROM_COMMIT"

# Cherry-pick commits sequentially from $FROM_COMMIT to $TO_COMMIT
echo "Cherry-picking commits from $FROM_COMMIT to $TO_COMMIT"
git cherry-pick "$FROM_COMMIT"^.."$TO_COMMIT"

# Squash all the commits into one
echo "Squashing all the commits into one commit"
git reset --soft "$FROM_COMMIT"^
GIT_AUTHOR_DATE="$TO_COMMIT_DATE" GIT_COMMITTER_DATE="$TO_COMMIT_DATE" git commit -m "$SQUASH_COMMIT_MESSAGE"

# Checkout the original branch
echo "Checking out the original branch '$CURRENT_BRANCH'"
git checkout "$CURRENT_BRANCH"

# Merge the squashed commit just after the starting commit
echo "Merging the squashed commit after $FROM_COMMIT"
git checkout "$FROM_COMMIT"
git cherry-pick "$TEMP_BRANCH"

# Delete the temporary branch
echo "Deleting temporary branch '$TEMP_BRANCH'"
git branch -D "$TEMP_BRANCH"

# Rebase to drop the original commits from history and resolve conflicts by accepting incoming changes
echo "Rebasing to drop the original commits"

# Start the rebase process
git rebase --onto "$FROM_COMMIT" "$TO_COMMIT"^ "$CURRENT_BRANCH"

# Handle conflicts by accepting incoming changes automatically
while [ $? -ne 0 ]; do
    echo "Conflict detected. Accepting incoming changes (from cherry-pick)..."
    
    # Resolve conflicts by accepting incoming changes for all conflicting files
    git diff --name-only --diff-filter=U | while read -r file; do
        git checkout --theirs "$file"
    done
    
    # Add the resolved files
    git add .

    # Amend the commit message to always use the provided squash commit message
    git commit --amend -m "$SQUASH_COMMIT_MESSAGE"

    # Continue the rebase
    git rebase --continue
done

echo "Process completed successfully!"
