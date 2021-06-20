#!/bin/bash

# --------------------------------------------------------------------------------
# Configure user settings
# --------------------------------------------------------------------------------
set -o errexit
set -o errtrace
set -o nounset

baseUser() {
  echo -e "\n****************************************\n"
  echo "  Create working directory"
  echo -e "\n****************************************\n"

  if [ ! -d "${HOME}"/wip ]; then
    mkdir -p "${HOME}"/wip
    echo "Working directory created."
  else
    echo "Working directory already exists."
  fi

  echo -e "\n****************************************\n"
  echo "  Create SSH keys"
  echo -e "\n****************************************\n"

  if [ ! -d "${HOME}"/.ssh ]; then
    mkdir -p "${HOME}"/.ssh
    ssh-keygen -t rsa -N "" -f "${HOME}"/.ssh/id_rsa.key
  else
    echo "SSH keys already exist."
  fi

  ls -lah "${HOME}"
}

main() {
  baseUser
}

main
