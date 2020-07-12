#!/bin/bash

# --------------------------------------------------------------------------------
# Install latest cloud tools for kernal version
# --------------------------------------------------------------------------------
set -o errexit
set -o errtrace
set -o nounset

validateArguments() {
  if [ -z "${PASSWORD-}" ]; then
    printf "\n\nError: 'PASSWORD' is required.\n\n"
    exit 1
  fi
}

cloudtools() {
  echo -e "\n****************************************\n"
  echo "  Reinstalling Cloud Tools"
  echo -e "\n****************************************\n"

  echo "${PASSWORD}" | sudo -S -- sh -c 'apt-get install -y linux-tools-virtual linux-cloud-tools-virtual linux-cloud-tools-'"$(uname -r)"''
}

main() {
  cloudtools
}

main
