#!/bin/bash

# ----------------------------------------
# Install latest updates available
# ----------------------------------------
set -o errexit
set -o errtrace
set -o nounset

validateArguments() {
  if [ -z "${PASSWORD-}" ]; then
    printf "\n\nError: 'PASSWORD' is required.\n\n"
    exit 1
  fi
}

installUpdates() {
  #install latest updates available
  echo -e '\n****************************************\n'
  echo '  Installing Latest Upgrades'
  echo -e '\n****************************************\n'
  echo $PASSWORD | sudo -S apt-get update
  echo $PASSWORD | sudo -S apt-get dist-upgrade -y
}

cleanup() {
  echo -e '\n****************************************\n'
  echo '  Removing outdated dependencies'
  echo -e '\n****************************************\n'
  echo $PASSWORD | sudo -S apt-get autoremove -y

  echo -e '\n****************************************\n'
  echo '  Create working directory'
  echo -e '\n****************************************\n'
  mkdir ~/wip
}

reboot() {
  echo -e '\n****************************************\n'
  echo '  Rebooting'
  echo -e '\n****************************************\n'
  echo $PASSWORD | sudo -S reboot
}

main() {
  validateArguments
  
  installUpdates
  
  cleanup
  
  reboot
}

main
