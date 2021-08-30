#!/bin/bash
# --------------------------------------------------------------------------------
# Cleanup after installation
# --------------------------------------------------------------------------------

set -o errexit;
set -o nounset;
set -o xtrace;
set -o pipefail;

DISK_USAGE_BEFORE_CLEANUP=$(df / -hBM)

# Removing unattended-upgrades package
apt-get remove -y --purge unattended-upgrades;
# Disable auto updates
systemctl stop apt-daily.timer;
systemctl disable apt-daily.timer;
systemctl mask apt-daily.service;
systemctl daemon-reload;

echo -e "\n\tcapture packages to purge\n"
echo "==> linux-headers"
purge_packages=$(dpkg --list | awk '{ print $2 }' | grep 'linux-headers' || true)
echo "==> linux-image"
purge_packages+=$(dpkg --list | awk '{ print $2 }' | grep 'linux-image-.*-generic' | grep -v "$(uname -r)" || true)
echo "==> linux-modules"
purge_packages+=$(dpkg --list | awk '{ print $2 }' | grep 'linux-modules-.*-generic' | grep -v "$(uname -r)" || true)
echo "==> linux-source"
purge_packages+=$(dpkg --list | awk '{ print $2 }' | grep linux-source || true)
echo "==> development packages"
purge_packages+=$(dpkg --list | awk '{ print $2 }' | grep -- '-dev\(:[a-z0-9]\+\)\?$' || true)
echo "==> development packages"
purge_packages+=$(dpkg --list | awk '{ print $2 }' | grep -- '-doc$' || true)

echo "purging packages"
apt-get -y purge "${purge_packages}"

echo "remove obsolete networking packages"
apt-get -y purge ppp pppconfig pppoeconf;

echo "remove packages we don't need"
apt-get -y purge popularity-contest command-not-found friendly-recovery bash-completion fonts-ubuntu-font-family-console laptop-detect motd-news-config usbutils grub-legacy-ec2;

# 21.04+ don't have this
echo "remove the installation-report"
apt-get -y purge popularity-contest installation-report || true;

echo "remove the console font"
apt-get -y purge fonts-ubuntu-console || true;

echo "removing command-not-found-data"
# 19.10+ don't have this package so fail gracefully
apt-get -y purge command-not-found-data || true;

# Exclude the files we don't need w/o uninstalling linux-firmware
echo "Setup dpkg excludes for linux-firmware"
cat <<EOF | cat >> /etc/dpkg/dpkg.cfg.d/excludes
#BENTO-BEGIN
path-exclude=/lib/firmware/*
path-exclude=/usr/share/doc/linux-firmware/*
#BENTO-END
EOF

echo "delete the massive firmware files"
rm -rf /lib/firmware/*;
rm -rf /usr/share/doc/linux-firmware/*;

echo "autoremoving packages and cleaning apt data"
apt-get -y autoremove;
apt-get -y clean;

echo "remove /usr/share/doc/"
rm -rf /usr/share/doc/*;

echo "remove /var/cache"
find /var/cache -type f -exec rm -rf {} \;

echo "truncate any logs that have built up during the install"
find /var/log -type f -exec truncate --size=0 {} \;

# Blank machine-id (DUID) so machines get unique ID generated on boot.
# https://www.freedesktop.org/software/systemd/man/machine-id.html#Initialization
echo "blank netplan machine-id (DUID) so machines get unique ID generated on boot"
if [ -f "/etc/machine-id" ]; then
  truncate -s 0 "/etc/machine-id";
fi

echo "remove the contents of /tmp and /var/tmp"
rm -rf /tmp/* /var/tmp/*;

echo "force a new random seed to be generated"
rm -f /var/lib/systemd/random-seed;

echo "clear the history so our install isn't there"
rm -f /root/.wget-hsts;
export HISTSIZE=0;

# Disk metrics
echo -e "\tDisk usage before cleanup:\n"
sleep 1;
echo "${DISK_USAGE_BEFORE_CLEANUP}";

echo -e "\tDisk usage after cleanup:\n"
sleep 1;
DISK_USAGE_AFTER_CLEANUP=$(df / -hBM);
sleep 1;
echo "${DISK_USAGE_AFTER_CLEANUP}";