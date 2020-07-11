#!/bin/bash

# ----------------------------------------
# Configure Ubuntu server environment
# ----------------------------------------
set -o errexit
set -o errtrace
set -o nounset

TERRAFORM_VERSION="0.12.21"
PACKER_VERSION="1.5.5"
VAGRANT_VERSION="2.2.7"
OS_NAME=$(lsb_release -cs)

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

basePackages() {
  #install latest updates available
  echo -e "\n****************************************\n"
  echo "  Installing base packages"
  echo -e "\n****************************************\n"

  echo "${PASSWORD}" | sudo -S -- sh -c 'apt-get install -y apt-transport-https ca-certificates curl git gnupg-agent python3-pip software-properties-common zsh unzip tldr neofetch shellcheck'
}

docker() {
  echo -e "\n****************************************\n"
  echo "  Installing Docker"
  echo -e "\n****************************************\n"

  echo "${PASSWORD}" | curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo -S -- sh -c 'apt-key add -'

  # Accounting for Ubuntu version 20.04 not officially being supported yet
  if [ "${OS_NAME}" != "bionic" ];
  then
    # Adding Docker repo    
    echo "${PASSWORD}" | sudo -S -- sh -c 'add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"'
  else
    # Adding Docker repo    
    echo "${PASSWORD}" | sudo -S -- sh -c 'add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"'
  fi

  # Installing Docker
  echo "${PASSWORD}" | sudo -S -- sh -c 'apt-get update'
  echo "${PASSWORD}" | sudo -S -- sh -c 'apt-get install -y docker-ce docker-ce-cli containerd.io'
}

node() {
  echo -e "\n****************************************\n"
  echo "  Installing Node"
  echo -e "\n****************************************\n"

  echo "${PASSWORD}" | curl -sL https://deb.nodesource.com/setup_12.x | sudo -SE -- sh -c 'bash -'
  echo "${PASSWORD}" | sudo -S -- sh -c 'apt-get install -y nodejs'
}

aws() {
  echo -e "\n****************************************\n"
  echo "  Installing AWS CLI"
  echo -e "\n****************************************\n"

  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  echo "${PASSWORD}" | sudo -S -- sh -c './aws/install'
  rm -rf aws
  rm awscliv2.zip
}

cli() {
  echo -e "\n****************************************\n"
  echo "  Installing CLI customizations"
  echo -e "\n****************************************\n"

  # Powerline
  pip3 install powerline-status

  # Oh-My-Zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  sleep 1

  # Powerlevel10K
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${HOME}"/.oh-my-zsh/custom/themes/powerlevel10k

  # Copy dotfiles
  if [ "${OS_NAME}" = "focal" ];
  then
    sed -i 's/python3.6/python3.8/' "${HOME}"/files/.zshrc
  fi

  mv "${HOME}"/files/.zshrc "${HOME}"/.zshrc

  mv "${HOME}"/files/.p10k.zsh "${HOME}"/.p10k.zsh

  rm -rf "${HOME}"/files

  # Set default shell
  echo "${PASSWORD}" | sudo -S -- sh -c 'usermod --shell '"$(command -v zsh)"' '"$(whoami)"''
}

hashicorp() {
  echo -e "\n****************************************\n"
  echo "  Install Terraform  ${TERRAFORM_VERSION}"
  echo -e "\n****************************************\n"

  curl -o "terraform.zip" "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
  unzip terraform.zip
  echo "${PASSWORD}" | sudo -S -- sh -c 'mv terraform /usr/bin/terraform'
  rm terraform.zip

  echo -e "\n****************************************\n"
  echo "  Install Packer ${PACKER_VERSION}"
  echo -e "\n****************************************\n"

  curl -o "packer.zip" "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
  unzip packer.zip
  echo "${PASSWORD}" | sudo -S -- sh -c 'mv packer /usr/bin/packer'
  rm packer.zip

  echo -e "\n****************************************\n"
  echo "  Install Vagrant ${VAGRANT_VERSION}"
  echo -e "\n****************************************\n"

  curl -o "vagrant.zip" "https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_linux_amd64.zip"
  unzip vagrant.zip
  echo "${PASSWORD}" | sudo -S -- sh -c 'mv vagrant /usr/bin/vagrant'
  rm vagrant.zip
}

reboot() {
  echo -e "\n****************************************\n"
  echo "  Rebooting"
  echo -e "\n****************************************\n"
  
  echo "${PASSWORD}" | sudo -S -- sh -c 'reboot'
}

main() {
  validateArguments
  
  basePackages

  docker

  node
  
  aws
  
  cli

  hashicorp
  
  reboot
}

main
