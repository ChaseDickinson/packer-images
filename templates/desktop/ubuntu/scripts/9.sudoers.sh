#!/bin/bash
# --------------------------------------------------------------------------------
# Configure sudo for vagrant user
# --------------------------------------------------------------------------------

set -o errexit;
set -o nounset;
set -o xtrace;
set -o pipefail;

sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers;

# Set up password-less sudo for the vagrant user
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/99_vagrant;
chmod 440 /etc/sudoers.d/99_vagrant;