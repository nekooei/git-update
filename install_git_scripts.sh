#!/bin/bash

# Function to check if the script is running as root (required for installing to /usr/local/bin)
check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
  fi
}

# Function to install a script to /usr/local/bin
install_script() {
  local script_name=$1
  local target_name=$2

  # Check if the script exists
  if [ ! -f "$script_name" ]; then
    echo "Error: $script_name not found!"
    exit 1
  fi

  # Copy the script to /usr/local/bin
  echo "Installing $script_name to /usr/local/bin as $target_name"
  cp "$script_name" /usr/local/bin/"$target_name"

  # Make the script executable
  chmod +x /usr/local/bin/"$target_name"
  echo "$target_name installed successfully."
}

# Ensure the script is run as root
check_root

# Install the scripts
install_script "update_commit.sh" "update_commit"
install_script "search_commits.sh" "search_commits"
install_script "cherry_pick_squash.sh" "cherry_pick_squash"

# Verify installation
echo ""
echo "Verifying installation..."
if command -v update_commit &> /dev/null && \
   command -v search_commits &> /dev/null && \
   command -v cherry_pick_squash &> /dev/null; then
  echo "All scripts installed successfully and are available as commands:"
  echo "  - update_commit"
  echo "  - search_commits"
  echo "  - cherry_pick_squash"
else
  echo "Error: One or more scripts failed to install."
  exit 1
fi
