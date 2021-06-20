#!/bin/bash

# --------------------------------------------------------------------------------
# Configure Ubuntu desktop environment
# --------------------------------------------------------------------------------
set -o errexit
set -o errtrace
set -o nounset

validateArguments() {
  if [ -z "${USERNAME-}" ]; then
    printf "\n\nError: 'USERNAME' is required.\n\n"
    exit 1
  fi
}

fonts() {
  echo -e "\n****************************************\n"
  echo "  Installing fonts"
  echo -e "\n****************************************\n"

  mkdir -p /tmp/nerd-fonts
  cd /tmp/nerd-fonts
  # Hack
  curl -fLo "Hack.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf?raw=true
  # Victor Mono
  curl -fLo "VictorMono.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/VictorMono/Regular/complete/Victor%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf?raw=true

  cd "${HOME}"
  mv /tmp/nerd-fonts /usr/share/fonts/truetype/nerd-fonts
  chown -R root:root /usr/share/fonts/truetype/nerd-fonts
  chmod 755 /usr/share/fonts/truetype/nerd-fonts
  find /usr/share/fonts/truetype/nerd-fonts -type f -iname '*.ttf' -exec chmod 644 {} \;

  fc-cache -fv
}

vsCode() {
  echo -e "\n****************************************\n"
  echo "  Installing Visual Studio Code"
  echo -e "\n****************************************\n"
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
  apt-get update
  apt-get install -y code
  rm packages.microsoft.gpg
}

shell() {
  echo -e "\n****************************************\n"
  echo "  Set Zsh as default shell"
  echo -e "\n****************************************\n"
  # Set default shell
  usermod --shell "$(command -v zsh)" "${USERNAME}"
}

changePassword() {
  echo -e "\n****************************************\n"
  echo "  Implementing password change prompt"
  echo -e "\n****************************************\n"

  mkdir -p /usr/local/scripts
  mv /tmp/files/passwd.sh /usr/local/scripts/passwd.sh
  sed -i -e 's/\\r$//' /usr/local/scripts/passwd.sh
  chmod +x /usr/local/scripts/passwd.sh
  cat <<EOF > /tmp/files/change_password.desktop
[Desktop Entry]
Name=Change Password
Icon=preferences-system
Comment=Script to change password on first launch
Exec=gnome-terminal -e "bash -c /usr/local/scripts/passwd.sh;bash"
Terminal=false
Type=Application
StartupNotify=true
Categories=GNOME;GTK;System;
OnlyShowIn=GNOME;Unity;
NoDisplay=true
AutostartCondition=unless-exists password-reset-done
EOF
  mv /tmp/files/change_password.desktop /etc/xdg/autostart/change_password.desktop
}

linuxVmTools() {
  if [ "$(lsb_release -cs)" = "bionic" ];
  then
    echo -e "\n****************************************\n"
    echo "  Installing prerequirements for Bionic"
    echo -e "\n****************************************\n"  

    apt-get install -y xserver-xorg-core xserver-xorg-input-all
  fi

  echo -e "\n****************************************\n"
  echo "  Installing Microsoft Linux-VM-Tools - $(lsb_release -cs)"
  echo -e "\n****************************************\n"

  cd /tmp/files
  chmod +x install.sh
  ./install.sh

  echo -e "\n****************************************\n"
  echo "  Autoremove"
  echo -e "\n****************************************\n"

  apt-get update
  apt-get autoremove -y
  apt-get clean
}

main() {
  validateArguments  

  fonts

  vsCode

  shell

  changePassword

  linuxVmTools
}

main
