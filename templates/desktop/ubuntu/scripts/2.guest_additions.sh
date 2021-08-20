#!/bin/bash
# --------------------------------------------------------------------------------
# Install VirtualBox Guest Additions
# --------------------------------------------------------------------------------

set -o errexit;
set -o nounset;
set -o xtrace;
set -o pipefail;

# set a default HOME_DIR environment variable if not set
HOME_DIR="/home/${USERNAME}";
ISO="VBoxGuestAdditions.iso";

# mount the ISO to /tmp/vbox
if [ -f "${HOME_DIR}/${ISO}" ]; then
  mkdir -p /tmp/vbox;
  mount "${HOME_DIR}/${ISO}" /tmp/vbox;
fi

echo "  Installing deps necessary to compile kernel modules"
# We install things like kernel-headers here vs. kickstart files so we make sure we install them for the updated kernel not the stock kernel
apt-get install -y build-essential dkms bzip2 tar linux-headers-"$(uname -r)"

echo "  Installing the vbox additions"
# this install script fails with non-zero exit codes for no apparent reason so we need better ways to know if it worked
/tmp/vbox/VBoxLinuxAdditions.run --nox11 || true
if ! modinfo vboxsf >/dev/null 2>&1; then
  echo "Cannot find vbox kernel module. Installation of guest additions unsuccessful!"
  exit 1
fi

echo "  Unmounting and removing the vbox ISO"
umount /tmp/vbox;
rm -rf /tmp/vbox;
rm -f "${HOME_DIR}"/*.iso;

echo "  Removing leftover logs"
rm -rf /var/log/vboxadd*;