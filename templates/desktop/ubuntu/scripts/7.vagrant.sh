#!/bin/bash
# --------------------------------------------------------------------------------
# Enable Vagrant functionality
# --------------------------------------------------------------------------------

set -o errexit;
set -o nounset;
set -o xtrace;
set -o pipefail;

# set a default HOME_DIR environment variable if not set
HOME_DIR="/home/${USERNAME}";

# Vagrant public key location
pubkey_url="https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub";

# Create and configure SSH directory
mkdir -p "${HOME_DIR}"/.ssh;
wget --no-check-certificate "$pubkey_url" -O "${HOME_DIR}"/.ssh/authorized_keys;
chown -R "${USERNAME}" "${HOME_DIR}"/.ssh;
chmod -R go-rwsx "${HOME_DIR}"/.ssh;