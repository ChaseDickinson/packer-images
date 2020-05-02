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
  echo -e "\n****************************************\n"
  echo "  Installing Latest Upgrades"
  echo -e "\n****************************************\n"

  echo "${PASSWORD}" | sudo -S -- sh -c 'apt-get update'
  echo "${PASSWORD}" | sudo -S -- sh -c 'apt-get dist-upgrade -y'
}

cleanup() {
  echo -e "\n****************************************\n"
  echo "  Removing outdated dependencies"
  echo -e "\n****************************************\n"

  echo "${PASSWORD}" | sudo -S -- sh -c 'apt-get autoremove -y'

  echo -e "\n****************************************\n"
  echo "  Create working directory"
  echo -e "\n****************************************\n"

  mkdir "${HOME}"/wip

  echo -e "\n****************************************\n"
  echo "  Create SSH keys"
  echo -e "\n****************************************\n"

  mkdir "${HOME}"/.ssh
  ssh-keygen -t rsa -N "" -f "${HOME}"/.ssh/id_rsa.key
}

reboot() {
  echo -e "\n****************************************\n"
  echo "  Rebooting"
  echo -e "\n****************************************\n"
  
  echo "${PASSWORD}" | sudo -S -- sh -c 'reboot'
}

main() {
  validateArguments
  
  installUpdates
  
  cleanup
  
  reboot
}

main
