#!/bin/bash
# ------------------------------------------------------------
# Configure common tools
# ------------------------------------------------------------

set -o errexit;
set -o nounset;
set -o xtrace;
#set -o pipefail;

DOCKER_COMPOSE_VERSION="latest";
OP_VERSION="latest";
PACKER_VERSION="latest";
TERRAFORM_VERSION="latest";
VAGRANT_VERSION="latest";
VIRTUALBOX_VERSION="latest";

#install latest updates available
apt-get update;
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  git \
  gnupg-agent \
  jq \
  libarchive-tools \
  neofetch \
  python3-pip \
  shellcheck \
  software-properties-common \
  tldr \
  tree \
  unzip \
  zsh;

if [ "${DOCKER_COMPOSE_VERSION}" = "latest" ]
then
  DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/git/refs/tags | jq -r '.[].ref' | grep -Po '[0-9]+\.[0-9]+\.[0-9](?!-)' | tail -1);
fi
echo "  DOCKER_COMPOSE_VERSION set to ${DOCKER_COMPOSE_VERSION}"

if [ "${OP_VERSION}" = "latest" ]
then
  OP_VERSION=$(curl -s https://app-updates.agilebits.com/product_history/CLI | grep -Po '[0-9]+\.[0-9]+\.[0-9]+' | head -1);
fi
echo "  OP_VERSION set to ${OP_VERSION}"

if [ "${PACKER_VERSION}" = "latest" ]
then
  PACKER_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r '.current_version');
fi
echo "  PACKER_VERSION set to ${PACKER_VERSION}"

if [ "${TERRAFORM_VERSION}" = "latest" ]
then
  TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r '.current_version');
fi
echo "  TERRAFORM_VERSION set to ${TERRAFORM_VERSION}"

if [ "${VAGRANT_VERSION}" = "latest" ]
then
  VAGRANT_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/vagrant | jq -r '.current_version');
fi
echo "  VAGRANT_VERSION set to ${VAGRANT_VERSION}"

if [ "${VIRTUALBOX_VERSION}" = "latest" ]
then
  VIRTUALBOX_VERSION=$(curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT);
fi
echo "  VIRTUALBOX_VERSION set to ${VIRTUALBOX_VERSION}"

# Installing VirtualBox
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -;
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -;
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" > /etc/apt/sources.list.d/virtualbox.list;

apt-get update;
apt-get install -y virtualbox-"${VIRTUALBOX_VERSION%.*}";

echo "  Installing VirtualBox Extension Pack"
wget https://download.virtualbox.org/virtualbox/"${VIRTUALBOX_VERSION}"/Oracle_VM_VirtualBox_Extension_Pack-"${VIRTUALBOX_VERSION}".vbox-extpack;
yes | VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-"${VIRTUALBOX_VERSION}".vbox-extpack;
rm Oracle_VM_VirtualBox_Extension_Pack-"${VIRTUALBOX_VERSION}".vbox-extpack;

# Installing Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -;
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable";

apt-get update;
apt-get install -y docker-ce docker-ce-cli containerd.io;

# Installing Docker Compose
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose;
chmod +x /usr/local/bin/docker-compose;

# Grant user permissions to Docker
usermod -aG docker "${USERNAME}";

# Installing AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip";
unzip awscliv2.zip;
./aws/install;
rm -rf aws;
rm awscliv2.zip;

# Install Packer
curl -o "packer.zip" "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip";
unzip packer.zip;
mv packer /usr/bin/packer;
rm packer.zip;

# Install Terraform
curl -o "terraform.zip" "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip";
unzip terraform.zip;
mv terraform /usr/bin/terraform;
rm terraform.zip;

# Install Vagrant
curl -o "vagrant.zip" "https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_linux_amd64.zip";
unzip vagrant.zip;
mv vagrant /usr/bin/vagrant;
rm vagrant.zip;

# Installing ansible-core
add-apt-repository --yes --update ppa:ansible/ansible;
apt-get install -y ansible;

# Installing 1Password CLI
curl -o "op_cli.zip" "https://cache.agilebits.com/dist/1P/op/pkg/v${OP_VERSION}/op_linux_amd64_v${OP_VERSION}.zip";
unzip op_cli.zip;
mv op /usr/bin/op;
rm op*;