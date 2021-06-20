#!/bin/bash

# --------------------------------------------------------------------------------
# Install latest cloud tools for kernal version
# --------------------------------------------------------------------------------
set -o errexit
set -o errtrace
set -o nounset

cloudtools() {
  echo -e "\n****************************************\n"
  echo "  Reinstalling Cloud Tools"
  echo -e "\n****************************************\n"

  apt-get install -y \
    linux-tools-virtual \
    linux-cloud-tools-virtual \
    linux-cloud-tools-"$(uname -r)"
}

main() {
  cloudtools
}

main