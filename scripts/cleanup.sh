#!/bin/bash

# --------------------------------------------------------------------------------
# Establish baseline on new machine
# --------------------------------------------------------------------------------
set -o errexit
set -o errtrace
set -o nounset

disableAutoUpdates() {
  echo -e "\n****************************************\n"
  echo "  Removing unattended-upgrades package"
  echo -e "\n****************************************\n"
  apt-get remove -y --purge unattended-upgrades

  echo -e "\n****************************************\n"
  echo "  Disable auto updates"
  echo -e "\n****************************************\n"

  systemctl stop apt-daily.timer
  systemctl disable apt-daily.timer
  systemctl mask apt-daily.service
  systemctl daemon-reload
}

cleanup() {
  echo -e "\n****************************************\n"
  echo "  apt-get autoremove"
  echo -e "\n****************************************\n"
  apt-get autoremove -y

  echo -e "\n****************************************\n"
  echo "  apt-get clean"
  echo -e "\n****************************************\n"
  apt-get clean
}

main() {
  disableAutoUpdates

  cleanup
}

main
