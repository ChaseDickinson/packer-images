#!/bin/bash -eux

# --------------------------------------------------------------------------------
# Configure user settings
# --------------------------------------------------------------------------------
baseUser() {
  # Create working directory
  if [ ! -d "${HOME}"/wip ]; then
    mkdir -p "${HOME}"/wip
    echo "Working directory created."
  else
    echo "Working directory already exists."
  fi
}

main() {
  baseUser
}

main
