#!/bin/bash
# --------------------------------------------------------------------------------
# Minimizing disk after installation
# --------------------------------------------------------------------------------

set -o errexit;
set -o nounset;
set -o xtrace;
set -o pipefail;

DISK_USAGE_BEFORE_MINIMIZE=$(df -BM --total --output=source,used,pcent | grep "total");

# Whiteout root
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}');
count=$((count-1));
dd if=/dev/zero of=/tmp/whitespace bs=1M count=$count || echo "dd exit code $? is suppressed";
rm /tmp/whitespace;

# Whiteout /boot
count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}');
count=$((count-1));
dd if=/dev/zero of=/boot/whitespace bs=1M count=$count || echo "dd exit code $? is suppressed";
rm /boot/whitespace;

set +e;
swapuuid="$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)";
case "$?" in
  2|0) ;;
  *) exit 1 ;;
esac
set -e;

if [ "x${swapuuid}" != "x" ]; then
  # Whiteout the swap partition to reduce box size
  # Swap is disabled till reboot
  swappart="$(readlink -f /dev/disk/by-uuid/"${swapuuid}")";
  /sbin/swapoff "$swappart" || true;
  dd if=/dev/zero of="$swappart" bs=1M || echo "dd exit code $? is suppressed";
  /sbin/mkswap -U "$swapuuid" "$swappart";
fi

sync;

echo -e "\tDisk usage before minimize:\n"
sleep 1;
echo "${DISK_USAGE_BEFORE_MINIMIZE}";

echo -e "\tDisk usage after minimize:\n"
sleep 1;
DISK_USAGE_AFTER_MINIMIZE=$(df -BM --total --output=source,used,pcent | grep "total");
sleep 1;
echo "${DISK_USAGE_AFTER_MINIMIZE}";