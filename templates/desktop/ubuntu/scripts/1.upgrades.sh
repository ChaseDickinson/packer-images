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