#!/bin/bash
# --------------------------------------------------------------------------------
# Reboot
# --------------------------------------------------------------------------------

set -o errexit;
set -o nounset;
set -o xtrace;
set -o pipefail;

# Reboot
sudo -S shutdown -r now;