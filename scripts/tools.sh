#!/bin/bash

# ------------------------------------------------------------
# Configure common tools
# ------------------------------------------------------------
set -o errexit
set -o errtrace
set -o nounset

CHEF_WORKSTATION_VERSION="20.7.96"
DOCKER_COMPOSE_VERSION="latest"
PACKER_VERSION="latest"
TERRAFORM_VERSION="latest"
VAGRANT_VERSION="latest"
VIRTUALBOX_VERSION="latest"

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

  echo "${PASSWORD}" | sudo -S -- sh -c "apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    gnupg-agent \
    jq \
    neofetch \
    python3-pip \
    shellcheck \
    software-properties-common \
    tldr \
    tree \
    zsh"
}

setVersions() {
  echo -e "\n****************************************\n"
  echo "  Setting versions to be installed"
  echo -e "\n****************************************\n"

  if [ "${CHEF_WORKSTATION_VERSION}" = "latest" ]
  then
    CHEF_WORKSTATION_VERSION=$(curl -s https://raw.githubusercontent.com/chef/chef-workstation/master/VERSION)
  fi
  echo -e "\nCHEF_WORKSTATION_VERSION set to ${CHEF_WORKSTATION_VERSION}\n"

  if [ "${DOCKER_COMPOSE_VERSION}" = "latest" ]
  then
    latest_tag=$(curl -s https://api.github.com/repos/docker/compose/git/refs/tags | jq -r '.[-1].ref')
    DOCKER_COMPOSE_VERSION="${latest_tag##*/}"
  fi
  echo -e "\nDOCKER_COMPOSE_VERSION set to ${DOCKER_COMPOSE_VERSION}\n"

  if [ "${PACKER_VERSION}" = "latest" ]
  then
    PACKER_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r '.current_version')
  fi
  echo -e "\nPACKER_VERSION set to ${PACKER_VERSION}\n"

  if [ "${TERRAFORM_VERSION}" = "latest" ]
  then
    TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r '.current_version')
  fi
  echo -e "\nTERRAFORM_VERSION set to ${TERRAFORM_VERSION}\n"

  if [ "${VAGRANT_VERSION}" = "latest" ]
  then
    VAGRANT_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/vagrant | jq -r '.current_version')
  fi
  echo -e "\nVAGRANT_VERSION set to ${VAGRANT_VERSION}\n"

  if [ "${VIRTUALBOX_VERSION}" = "latest" ]
  then
    VIRTUALBOX_VERSION=$(curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT)
  fi
  echo -e "\nVIRTUALBOX_VERSION set to ${VIRTUALBOX_VERSION}\n"
}

virtualbox() {
  echo -e "\n****************************************\n"
  echo "  Installing VirtualBox - ${VIRTUALBOX_VERSION}"
  echo -e "\n****************************************\n"

  echo "${PASSWORD}" | wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo -S -- sh -c "apt-key add -"
  echo "${PASSWORD}" | wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo -S -- sh -c "apt-key add -"
  echo "${PASSWORD}" | sudo -S -- sh -c "echo \"deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib\" > /etc/apt/sources.list.d/virtualbox.list"

  echo "${PASSWORD}" | sudo -S -- sh -c "apt-get update"
  echo "${PASSWORD}" | sudo -S -- sh -c "apt-get install -y virtualbox-${VIRTUALBOX_VERSION%.*}"
  
  wget https://download.virtualbox.org/virtualbox/"${VIRTUALBOX_VERSION}"/Oracle_VM_VirtualBox_Extension_Pack-"${VIRTUALBOX_VERSION}".vbox-extpack
  echo "${PASSWORD}" | sudo -SE -- sh -c "yes | VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-${VIRTUALBOX_VERSION}.vbox-extpack"
  rm Oracle_VM_VirtualBox_Extension_Pack-"${VIRTUALBOX_VERSION}".vbox-extpack
}

docker() {
  echo -e "\n****************************************\n"
  echo "  Installing Docker"
  echo -e "\n****************************************\n"

  # Installing Docker
  echo "${PASSWORD}" | curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo -S -- sh -c "apt-key add -"
  echo "${PASSWORD}" | sudo -S -- sh -c "add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\""
  echo "${PASSWORD}" | sudo -S -- sh -c "apt-get update"
  echo "${PASSWORD}" | sudo -S -- sh -c "apt-get install -y docker-ce docker-ce-cli containerd.io"

  echo -e "\n****************************************\n"
  echo "  Installing Docker Compose - ${DOCKER_COMPOSE_VERSION}"
  echo -e "\n****************************************\n"

  # Installing Docker Compose
  echo "${PASSWORD}" | sudo -S -- sh -c "curl -L \"https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose"
  echo "${PASSWORD}" | sudo -S -- sh -c "chmod +x /usr/local/bin/docker-compose"

  # Grant user permissions to Docker
  echo "${PASSWORD}" | sudo -S -- sh -c "usermod -aG docker $USER"
}

node() {
  echo -e "\n****************************************\n"
  echo "  Installing Node"
  echo -e "\n****************************************\n"

  echo "${PASSWORD}" | curl -sL https://deb.nodesource.com/setup_12.x | sudo -SE -- sh -c "bash -"
  echo "${PASSWORD}" | sudo -S -- sh -c "apt-get install -y nodejs"
}

aws() {
  echo -e "\n****************************************\n"
  echo "  Installing AWS CLI"
  echo -e "\n****************************************\n"

  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  echo "${PASSWORD}" | sudo -S -- sh -c "./aws/install"
  rm -rf aws
  rm awscliv2.zip
}

azure() {
  echo -e "\n****************************************\n"
  echo "  Installing Azure CLI"
  echo -e "\n****************************************\n"

  echo "${PASSWORD}" | curl -sL https://aka.ms/InstallAzureCLIDeb | sudo -SE -- sh -c "bash -"
}

hashicorp() {
  echo -e "\n****************************************\n"
  echo "  Install Packer - ${PACKER_VERSION}"
  echo -e "\n****************************************\n"

  curl -o "packer.zip" "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
  unzip packer.zip
  echo "${PASSWORD}" | sudo -S -- sh -c "mv packer /usr/bin/packer"
  rm packer.zip

  echo -e "\n****************************************\n"
  echo "  Install Terraform - ${TERRAFORM_VERSION}"
  echo -e "\n****************************************\n"

  curl -o "terraform.zip" "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
  unzip terraform.zip
  echo "${PASSWORD}" | sudo -S -- sh -c "mv terraform /usr/bin/terraform"
  rm terraform.zip

  echo -e "\n****************************************\n"
  echo "  Install Vagrant - ${VAGRANT_VERSION}"
  echo -e "\n****************************************\n"

  curl -o "vagrant.zip" "https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_linux_amd64.zip"
  unzip vagrant.zip
  echo "${PASSWORD}" | sudo -S -- sh -c "mv vagrant /usr/bin/vagrant"
  rm vagrant.zip
}

chef() {
  echo -e "\n****************************************\n"
  echo "  Installing Chef Workstation - ${CHEF_WORKSTATION_VERSION}"
  echo -e "\n****************************************\n"

  curl -o "chef-workstation.deb" "https://packages.chef.io/files/stable/chef-workstation/${CHEF_WORKSTATION_VERSION}/ubuntu/$(lsb_release -rs)/chef-workstation_${CHEF_WORKSTATION_VERSION}-1_amd64.deb"
  echo "${PASSWORD}" | sudo -S -- sh -c "dpkg -i chef-workstation.deb"
  rm chef-workstation.deb
}

reboot() {
  echo -e "\n****************************************\n"
  echo "  Rebooting"
  echo -e "\n****************************************\n"
  
  echo "${PASSWORD}" | sudo -S -- sh -c "reboot"
}

main() {
  validateArguments

  basePackages

  setVersions

  virtualbox

  docker

  node
  
  aws

  azure

  hashicorp

  chef

  reboot
}

main
