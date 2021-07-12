#!/bin/bash -eux

# --------------------------------------------------------------------------------
# Ensure latest upgrades are installed
# --------------------------------------------------------------------------------
installUpdates() {
  #install latest updates available
  echo "****************************************"
  echo "  Install Latest Upgrades"
  echo "****************************************"

  apt-get update
  apt-get dist-upgrade -y
}

main() {
  installUpdates
}

main
