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

  # Create SSH keys
  if [ ! -d "${HOME}"/.ssh ]; then
    mkdir -p "${HOME}"/.ssh
    ssh-keygen -t rsa -b 4096 -N "" -f "${HOME}"/.ssh/id_rsa.key
  else
    echo "SSH keys already exist."
  fi
}

main() {
  baseUser
}

main
