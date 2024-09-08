
# Git Scripts Bundle

This bundle contains two useful Git-related bash scripts:

1. `update_commit.sh` - Script to update a specific commit message or author.
2. `search_commits.sh` - Script to search for commits based on commit messages, patterns, author emails, and case-insensitive options.

## Script 1: `update_commit.sh`

### Usage
```bash
./update_commit.sh <commit-sha> "<new-message>" "[new-author]"
```

- **commit-sha**: The SHA of the commit you want to update.
- **new-message**: The new commit message.
- **new-author** (optional): The new author, in the format `"Author Name <author@example.com>"`.

### Example
```bash
./update_commit.sh abc123 "Fixed login issue" "John Doe <john@example.com>"
```

This will change the commit message of the commit `abc123` and also change the author if provided.

## Script 2: `search_commits.sh`

### Usage
```bash
./search_commits.sh [-e|--exact] [-i|--insensitive] [-a|--author <author-email>] [<string-pattern>]
```

- **-e | --exact**: Search for an exact commit message match.
- **-i | --insensitive**: Perform a case-insensitive search.
- **-a | --author <author-email>**: Search commits by author email.
- **string-pattern**: A string or pattern to search for in commit messages.

### Examples

- Search for commits with messages containing "bugfix":
  ```bash
  ./search_commits.sh "bugfix"
  ```

- Search for exact commit messages:
  ```bash
  ./search_commits.sh -e "Fixed login bug"
  ```

- Search for commits by a specific author:
  ```bash
  ./search_commits.sh -a "john@example.com"
  ```

- Perform a case-insensitive search:
  ```bash
  ./search_commits.sh -i "fix"
  ```

This bundle provides flexibility for manipulating and searching through Git commit histories with ease.
