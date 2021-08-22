#!/bin/bash
# ------------------------------------------------------------
# Install Ansible
# ------------------------------------------------------------

set -o errexit;
set -o nounset;
set -o xtrace;
set -o pipefail;

python3 -m pip install --user ansible ansible-lint psutil