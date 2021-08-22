#!/bin/bash
# --------------------------------------------------------------------------------
# Ensure latest upgrades are installed
# --------------------------------------------------------------------------------

set -o errexit;
set -o nounset;
set -o xtrace;
set -o pipefail;

apt-get update;
apt-get dist-upgrade -y;

# Capturing box creation date
date > /etc/vagrant_box_build_date;

# Creating Ansible default hosts file
mkdir /etc/ansible
touch /etc/ansible/hosts