#!/bin/sh -eux

echo "Install latest updates"
apt-get update
apt-get upgrade -y