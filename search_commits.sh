#!/bin/bash

# Function to display usage instructions
usage() {
  echo "Usage: $0 [-e|--exact] [-i|--insensitive] [-a|--author <author-email>] [<string-pattern>]"
  exit 1
}

# Check if no arguments are provided
if [ $# -lt 1 ]; then
  usage
fi

# Initialize variables
SEARCH_PATTERN=""
EXACT_MATCH=false
CASE_INSENSITIVE=false
AUTHOR_EMAIL=""

# Parse options and arguments
while [[ "$1" != "" ]]; do
  case $1 in
    -e | --exact )
      EXACT_MATCH=true
      ;;
    -i | --insensitive )
      CASE_INSENSITIVE=true
      ;;
    -a | --author )
      shift
      AUTHOR_EMAIL=$1
      ;;
    * )
      SEARCH_PATTERN=$1
      ;;
  esac
  shift
done

# Check if at least a search pattern or author email was provided
if [ -z "$SEARCH_PATTERN" ] && [ -z "$AUTHOR_EMAIL" ]; then
  usage
fi

# Build the git log command
GIT_COMMAND="git log --all"

# If case-insensitive flag is set, add the -i option to git log
if [ "$CASE_INSENSITIVE" = true ]; then
  GIT_COMMAND="$GIT_COMMAND -i"
fi

# If an author email is provided, add it to the command
if [ -n "$AUTHOR_EMAIL" ]; then
  GIT_COMMAND="$GIT_COMMAND --author="$AUTHOR_EMAIL""
fi

# If a search pattern is provided
if [ -n "$SEARCH_PATTERN" ]; then
  # If exact match flag is set, search for the exact string
  if [ "$EXACT_MATCH" = true ]; then
    GIT_COMMAND="$GIT_COMMAND --grep="^${SEARCH_PATTERN}$""
  else
    GIT_COMMAND="$GIT_COMMAND --grep="$SEARCH_PATTERN""
  fi
fi

# Add formatting to the output
GIT_COMMAND="$GIT_COMMAND --pretty=format:"%h - %an <%ae> - %s""

# Evaluate the command and execute it
eval $GIT_COMMAND

# Explanation:
# --all                     : Search through all branches (not just the current branch).
# -i                        : Enables case-insensitive search.
# --author="<email>"         : Filters commits by author email.
# --grep="^${SEARCH_PATTERN}$" : For exact match, we use '^' and '$' to match the entire message.
# --pretty=format:"%h - %an <%ae> - %s"  : Output the short commit hash (%h), author name (%an), author email (%ae), and the commit message (%s).
