#!/bin/bash
# --------------------------------------------------------------------------------
# Configure user settings
# --------------------------------------------------------------------------------

set -o errexit;
set -o nounset;
set -o xtrace;
set -o pipefail;

# set a default HOME_DIR environment variable if not set
HOME_DIR="/home/${USERNAME}";

# Create working directory
if [ ! -d "${HOME_DIR}"/wip ]; then
  mkdir -p "${HOME_DIR}"/wip;
  echo "Working directory created.";
else
  echo "Working directory already exists.";
fi

# Configuring GNOME settings
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.gedit.desktop', 'firefox.desktop', 'gnome-control-center.desktop']";
gsettings set org.gnome.desktop.session idle-delay 0;
gsettings set org.gnome.desktop.interface text-scaling-factor 1.25;
gsettings set org.gnome.shell.extensions.dash-to-dock click-action minimize;

# Suppress Welcome Wizard
touch "${HOME_DIR}"/.config/gnome-initial-setup-done;