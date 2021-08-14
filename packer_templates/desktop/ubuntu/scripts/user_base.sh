#!/bin/bash -eux

# --------------------------------------------------------------------------------
# Configure user settings
# --------------------------------------------------------------------------------
baseUser() {
  # Create working directory
  if [ ! -d "${HOME}"/wip ]; then
    mkdir -p "${HOME}"/wip
    echo "Working directory created."
  else
    echo "Working directory already exists."
  fi
}

gnomeConfig() {
  # Configuring GNOME settings
  gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.gedit.desktop', 'firefox.desktop', 'gnome-control-center.desktop']"
  gsettings set org.gnome.desktop.session idle-delay 0
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
  gsettings set org.gnome.shell.extensions.dash-to-dock click-action minimize

  # Suppress Welcome Wizard
  touch "${HOME}"/.config/gnome-initial-setup-done
}

main() {
  baseUser

  gnomeConfig
}

main
