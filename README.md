
# Git Scripts Bundle

This bundle contains three useful Git-related bash scripts:

1. `update_commit.sh` - Script to update a specific commit message or author.
2. `search_commits.sh` - Script to search for commits based on commit messages, patterns, author emails, and case-insensitive options.
3. `cherry_pick_squash.sh` - Script to create a branch from a starting commit, cherry-pick a range of commits sequentially, squash them into one, merge them into the source branch, and remove the commits from history.

---

## Installation

To install the scripts globally on your system, run the following installation script. This will install the scripts to `/usr/local/bin` and make them available as commands you can use anywhere:

### Steps to Install:

1. clone repository

2. Run the installation script with `sudo`:

   ```bash
   sudo ./install_git_scripts.sh
   ```

This will install the following commands:

- `update_commit`: For updating a specific commit.
- `search_commits`: For searching through commit messages, patterns, and authors.
- `cherry_pick_squash`: For cherry-picking and squashing commits into a single commit.

---

## Script 1: `update_commit`

### Usage
```bash
update_commit <commit-sha> "<new-message>" "[new-author]"
```

- **commit-sha**: The SHA of the commit you want to update.
- **new-message**: The new commit message.
- **new-author** (optional): The new author, in the format `"Author Name <author@example.com>"`.

### Example
```bash
update_commit abc123 "Fixed login issue" "John Doe <john@example.com>"
```

---

## Script 2: `search_commits`

### Usage
```bash
search_commits [-e|--exact] [-i|--insensitive] [-a|--author <author-email>] [<string-pattern>]
```

- **-e | --exact**: Search for an exact commit message match.
- **-i | --insensitive**: Perform a case-insensitive search.
- **-a | --author <author-email>**: Search commits by author email.
- **string-pattern**: A string or pattern to search for in commit messages.

### Examples

- Search for commits with messages containing "bugfix":
  ```bash
  search_commits "bugfix"
  ```

- Search for exact commit messages:
  ```bash
  search_commits -e "Fixed login bug"
  ```

- Search for commits by a specific author:
  ```bash
  search_commits -a "john@example.com"
  ```

- Perform a case-insensitive search:
  ```bash
  search_commits -i "fix"
  ```

---

## Script 3: `cherry_pick_squash`

### Usage
```bash
cherry_pick_squash <from-commit-sha> <to-commit-sha> <temporary-branch-name> "<squash-commit-message>"
```

- **from-commit-sha**: The SHA of the starting commit in the range you want to squash.
- **to-commit-sha**: The SHA of the ending commit in the range you want to squash.
- **temporary-branch-name**: The name of the temporary branch that will be created during the process.
- **squash-commit-message**: The commit message for the squashed commit.

### Example
```bash
cherry_pick_squash abc123 def456 temp-branch "Merged feature updates"
```

This script will:
1. Create a temporary branch from `abc123`.
2. Cherry-pick commits from `abc123` to `def456`.
3. Squash them into one commit with the message "Merged feature updates".
4. Merge the squashed commit into the original branch.
5. Delete the temporary branch.
6. Remove the original commits from history by rebasing.

---

This bundle provides flexibility for manipulating and searching through Git commit histories with ease. Always ensure you have a clean working directory and are aware of potential issues when rewriting history in shared repositories.
