#!/bin/bash

# --------------------------------------------------------------------------------
# Configure Ubuntu desktop environment
# --------------------------------------------------------------------------------
set -o errexit
set -o errtrace
set -o nounset

validateArguments() {
  if [ -z "${PASSWORD-}" ]; then
    printf "\n\nError: 'PASSWORD' is required.\n\n"
    exit 1
  fi
  if [ -z "${USERNAME-}" ]; then
    printf "\n\nError: 'USERNAME' is required.\n\n"
    exit 1
  fi
}

fonts() {
  echo -e "\n****************************************\n"
  echo "  Installing fonts"
  echo -e "\n****************************************\n"

  mkdir "${HOME}"/nerd-fonts
  cd "${HOME}"/nerd-fonts
  # Hack
  curl -fLo "Hack.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf?raw=true

  cd "${HOME}"
  echo "${PASSWORD}" | sudo -S -- sh -c "mv /home/${USERNAME}/nerd-fonts /usr/share/fonts/truetype/nerd-fonts"
  echo "${PASSWORD}" | sudo -S -- sh -c "chown -R root:root /usr/share/fonts/truetype/nerd-fonts"
  echo "${PASSWORD}" | sudo -S -- sh -c "chmod 755 /usr/share/fonts/truetype/nerd-fonts"
  echo "${PASSWORD}" | sudo -S -- sh -c "find /usr/share/fonts/truetype/nerd-fonts -type f -iname *.ttf -exec chmod 644 {} \;"

  echo "${PASSWORD}" | sudo -S -- sh -c "fc-cache -fv"
}

vsCode() {
  echo -e "\n****************************************\n"
  echo "  Installing Visual Studio Code"
  echo -e "\n****************************************\n"

  sleep 1

  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  echo "${PASSWORD}" | sudo -S -- sh -c "install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/"
  echo "${PASSWORD}" | sudo -S -- sh -c "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main\" > /etc/apt/sources.list.d/vscode.list"
  echo "${PASSWORD}" | sudo -S -- sh -c "apt-get update"
  echo "${PASSWORD}" | sudo -S -- sh -c "apt-get install -y code"
  rm packages.microsoft.gpg
}

cli() {
  echo -e "\n****************************************\n"
  echo "  Installing CLI customizations"
  echo -e "\n****************************************\n"

  # Powerline
  pip3 install powerline-status

  # Oh-My-Zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  sleep 1

  # Powerlevel10K
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${HOME}"/.oh-my-zsh/custom/themes/powerlevel10k

  # Copy dotfiles
  if [ "$(lsb_release -cs)" = "focal" ];
  then
    sed -i 's/python3.6/python3.8/' "${HOME}"/files/.zshrc
  fi

  mv "${HOME}"/files/.zshrc "${HOME}"/.zshrc

  mv "${HOME}"/files/.p10k.zsh "${HOME}"/.p10k.zsh

  # Set default shell
  echo "${PASSWORD}" | sudo -S -- sh -c "usermod --shell $(command -v zsh) $(whoami)"
}

gnomeConfig() {
  echo -e "\n****************************************\n"
  echo "  Configuring GNOME settings"
  echo -e "\n****************************************\n"

  gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'code.desktop', 'virtualbox.desktop', 'org.gnome.gedit.desktop', 'firefox.desktop', 'gnome-control-center.desktop']"
  gsettings set org.gnome.desktop.session idle-delay 0
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
  gsettings set org.gnome.shell.extensions.dash-to-dock click-action minimize

  echo -e "\n****************************************\n"
  echo "  Configuring terminal theme"
  echo -e "\n****************************************\n"

  profile=$(gsettings get org.gnome.Terminal.ProfilesList default | xargs)
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ default-size-rows 30
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ default-size-columns 120
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ font 'Hack Nerd Font 14'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ use-system-font false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ use-theme-colors false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ background-color '#0D0D17'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ foreground-color '#E6E5E5'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ palette "['#17384C', '#D15123', '#027C9B', '#FCA02F', '#1E4950', '#68D4F1', '#50A3B5', '#DEB88D', '#434B53', '#D48678', '#628D98', '#FDD39F', '#1BBCDD', '#BBE3EE', '#87ACB4', '#FEE4CE']"
}

vsCodeConfig() {
  echo -e "\n****************************************\n"
  echo "  Installing VS Code extensions"
  echo -e "\n****************************************\n"

  #remove whitespace from list
  sed -i 's/[[:space:]]*$//' "${HOME}"/files/code_extensions.list
  < "${HOME}"/files/code_extensions.list xargs -L 1 code --install-extension
  rm "${HOME}"/files/code_extensions.list

  echo -e "\n****************************************\n"
  echo "  Copying VS Code settings"
  echo -e "\n****************************************\n"

  mkdir -p "${HOME}"/.config/Code/User
  mv "${HOME}"/files/settings.json "${HOME}"/.config/Code/User/settings.json
}

changePassword() {
  echo -e "\n****************************************\n"
  echo "  Implementing password change prompt"
  echo -e "\n****************************************\n"

  echo "${PASSWORD}" | sudo -S -- sh -c "mkdir -p /usr/local/scripts"
  echo "${PASSWORD}" | sudo -S -- sh -c "mv /home/${USERNAME}/files/passwd.sh /usr/local/scripts/passwd.sh"
  echo "${PASSWORD}" | sudo -S -- sh -c "sed -i -e 's/\\r$//' /usr/local/scripts/passwd.sh"
  echo "${PASSWORD}" | sudo -S -- sh -c "chmod +x /usr/local/scripts/passwd.sh"
  cat <<EOF > "${HOME}"/files/change_password.desktop
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
  # echo "${PASSWORD}" | sudo -S -- sh -c "mv /etc/xdg/autostart/gnome-initial-setup-first-login.desktop /etc/xdg/autostart/gnome-initial-setup-first-login.desktop.old"
  touch "${HOME}"/.config/gnome-initial-setup-done
  echo "${PASSWORD}" | sudo -S -- sh -c "mv /home/${USERNAME}/files/change_password.desktop /etc/xdg/autostart/change_password.desktop"
  mv "${HOME}"/files/install.sh "${HOME}"/install.sh
  rm -Rf "${HOME}"/files
}

linuxVmTools() {
  if [ "$(lsb_release -cs)" = "bionic" ];
  then
    echo -e "\n****************************************\n"
    echo "  Installing prerequirements for Bionic"
    echo -e "\n****************************************\n"  

    echo "${PASSWORD}" | sudo -S -- sh -c "apt-get install -y xserver-xorg-core xserver-xorg-input-all"
  fi

  echo -e "\n****************************************\n"
  echo "  Installing Microsoft Linux-VM-Tools - $(lsb_release -cs)"
  echo -e "\n****************************************\n"

  cd "${HOME}"
  chmod +x install.sh
  echo "${PASSWORD}" | sudo -S -- bash -c "./install.sh"
  rm install.sh

  echo -e "\n****************************************\n"
  echo "  Autoremove"
  echo -e "\n****************************************\n"

  echo "${PASSWORD}" | sudo -S -- sh -c "apt-get update"
  echo "${PASSWORD}" | sudo -S -- sh -c "apt-get autoremove -y"
}

main() {
  validateArguments  

  fonts
  
  vsCode
  
  cli

  gnomeConfig
  
  vsCodeConfig
  
  changePassword

  linuxVmTools
}

main
