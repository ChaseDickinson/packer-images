#!/bin/bash

# --------------------------------------------------------------------------------
# Ensure latest upgrades are installed
# --------------------------------------------------------------------------------
set -o errexit
set -o errtrace
set -o nounset

installUpdates() {
  #install latest updates available
  echo -e "\n****************************************\n"
  echo "  Install Latest Upgrades"
  echo -e "\n****************************************\n"

  apt-get update
  apt-get dist-upgrade -y
}

main() {
  installUpdates
}

main
