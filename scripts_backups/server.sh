#!/bin/bash

# --------------------------------------------------------------------------------
# Configure Ubuntu server environment
# --------------------------------------------------------------------------------
set -o errexit
set -o errtrace
set -o nounset

validateArguments() {
  if [ -z "${PASSWORD-}" ]; then
    printf "\n\nError: 'PASSWORD' is required.\n\n"
    exit 1
  fi
  if [ -z "${USERNAME-}" ]; then
    printf "\n\nError: 'USERNAME' is required.\n\n"
    exit 1
  fi
}

main() {
  echo -e "\n****************************************\n"
  echo "  Installing Ubuntu Server"
  echo -e "\n****************************************\n"
}

main
