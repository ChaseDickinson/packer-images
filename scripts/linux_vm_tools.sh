#!/bin/bash

# --------------------------------------------------------------------------------
# Enable Enhanced VM functionality for Hyper-V
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

prerequirements() {
  echo -e "\n****************************************\n"
  echo "  Installing prerequirements for Bionic"
  echo -e "\n****************************************\n"  

  echo "${PASSWORD}" | sudo -S -- sh -c "apt-get install -y xserver-xorg-core xserver-xorg-input-all"
}

linuxVmTools() {
  echo -e "\n****************************************\n"
  echo "  Installing Microsoft Linux-VM-Tools - $(lsb_release -cs)"
  echo -e "\n****************************************\n"

  cd "${HOME}"
  chmod +x install.sh
  echo "${PASSWORD}" | sudo -S -- bash -c "./install.sh"
  rm install.sh
}

autoremove() {
  echo -e "\n****************************************\n"
  echo "  Autoremove"
  echo -e "\n****************************************\n"

  echo "${PASSWORD}" | sudo -S -- sh -c "apt-get update"
  echo "${PASSWORD}" | sudo -S -- sh -c "apt-get autoremove -y"
}

main() {
  validateArguments

  sleep 10

  if [ "$(lsb_release -cs)" = "bionic" ];
  then
    prerequirements
  fi
  
  linuxVmTools

  autoremove
}

main
