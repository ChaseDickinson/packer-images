#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

# --------------------------------------------------------------------------------
# Ensure latest upgrades are installed
# --------------------------------------------------------------------------------
installUpdates() {
  #install latest updates available
  apt-get update
  apt-get dist-upgrade -y
}

main() {
  installUpdates
}

main
