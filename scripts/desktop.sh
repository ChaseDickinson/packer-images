#!/bin/bash

# ----------------------------------------
# Configure Ubuntu desktop environment
# ----------------------------------------
set -o errexit
set -o errtrace
set -o nounset

TERRAFORM_VERSION="0.12.21"
PACKER_VERSION="1.5.5"
VAGRANT_VERSION="2.2.7"
OS_NAME=$(lsb_release -cs)

validateArguments() {
  if [ -z "${PASSWORD-}" ]; then
    printf "\n\nError: 'PASSWORD' is required.\n\n"
    exit 1
  fi
}

basePackages() {
  #install latest updates available
  echo -e "\n****************************************\n"
  echo "  Installing base packages"
  echo -e "\n****************************************\n"

  echo $PASSWORD | sudo -S apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  git \
  gnupg-agent \
  python3-pip \
  software-properties-common \
  zsh
}

fonts() {
  echo -e "\n****************************************\n"
  echo "  Installing fonts"
  echo -e "\n****************************************\n"

  mkdir ~/nerd-fonts
  cd ~/nerd-fonts
  # Hack
  curl -fLo "Hack.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf?raw=true

  cd ~
  echo $PASSWORD | sudo -S mv ~/nerd-fonts /usr/share/fonts/truetype/nerd-fonts
  echo $PASSWORD | sudo -S chown -R root:root /usr/share/fonts/truetype/nerd-fonts
  echo $PASSWORD | sudo -S chmod 755 /usr/share/fonts/truetype/nerd-fonts
  echo $PASSWORD | sudo -S find /usr/share/fonts/truetype/nerd-fonts -type f -iname "*.ttf" -exec chmod 644 {} \;

  echo $PASSWORD | sudo -S fc-cache -fv
}

vsCode() {
  echo -e "\n****************************************\n"
  echo "  Installing Visual Studio Code"
  echo -e "\n****************************************\n"

  sleep 1

  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  echo $PASSWORD | sudo -S install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  echo $PASSWORD | sudo -S sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  echo $PASSWORD | sudo -S apt-get update
  echo $PASSWORD | sudo -S apt-get install -y code 
  rm packages.microsoft.gpg
}

docker() {
  echo -e "\n****************************************\n"
  echo "  Installing Docker"
  echo -e "\n****************************************\n"

  # Accounting for Ubuntu version 20.04 not officially being supported yet
  if [ "${OS_NAME}" != "bionic" ]
  then
    # Adding Docker repo    
    echo $PASSWORD | curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo -S apt-key add -
    echo $PASSWORD | sudo -S add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      bionic \
      stable"
    # Installing Docker
    echo $PASSWORD | sudo -S apt-get update
    echo $PASSWORD | sudo -S apt-get install -y docker-ce docker-ce-cli containerd.io
  else
    # Adding Docker repo    
    echo $PASSWORD | curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo -S apt-key add -
    echo $PASSWORD | sudo -S add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
    # Installing Docker
    echo $PASSWORD | sudo -S apt-get update
    echo $PASSWORD | sudo -S apt-get install -y docker-ce docker-ce-cli containerd.io
  fi
}

node() {
  echo -e "\n****************************************\n"
  echo "  Installing Node"
  echo -e "\n****************************************\n"

  echo $PASSWORD | curl -sL https://deb.nodesource.com/setup_12.x | sudo -S -E bash -
  echo $PASSWORD | sudo -S apt-get install -y nodejs
}

aws() {
  echo -e "\n****************************************\n"
  echo "  Installing AWS CLI"
  echo -e "\n****************************************\n"

  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  echo $PASSWORD | sudo -S ./aws/install
  rm -rf aws
  rm awscliv2.zip
}

cli() {
  echo -e "\n****************************************\n"
  echo "  Installing CLI customizations"
  echo -e "\n****************************************\n"

  # Powerline
  pip3 install powerline-status

  # Oh-My-Zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  # Powerlevel10K
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

  # Copy .zshrc file
  mv ~/files/.zshrc ~/.zshrc

  # Set default shell
  echo $PASSWORD | sudo -S usermod --shell $(which zsh) $(whoami)
}

hashicorp() {
  echo -e "\n****************************************\n"
  echo "  Install Terraform  ${TERRAFORM_VERSION}"
  echo -e "\n****************************************\n"

  curl -o "terraform.zip" "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
  unzip terraform.zip
  echo $PASSWORD | sudo -S mv terraform /usr/bin/terraform
  rm terraform.zip

  echo -e "\n****************************************\n"
  echo "  Install Packer ${PACKER_VERSION}"
  echo -e "\n****************************************\n"

  curl -o "packer.zip" "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
  unzip packer.zip
  echo $PASSWORD | sudo -S mv packer /usr/bin/packer
  rm packer.zip

  echo -e "\n****************************************\n"
  echo "  Install Vagrant ${VAGRANT_VERSION}"
  echo -e "\n****************************************\n"

  curl -o "vagrant.zip" "https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_linux_amd64.zip"
  unzip vagrant.zip
  echo $PASSWORD | sudo -S mv vagrant /usr/bin/vagrant
  rm vagrant.zip
}

# TODO - Fix these for 20.04
# dconf-WARNING **: 17:41:33.704: failed to commit changes to dconf: Cannot autolaunch D-Bus without X11 $DISPLAY
# dconf-WARNING **: 17:41:33.736: failed to commit changes to dconf: Cannot autolaunch D-Bus without X11 $DISPLAY
gnomeConfig() {
  echo -e "\n****************************************\n"
  echo "  Configuring desktop favorites"
  echo -e "\n****************************************\n"

  gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'code.desktop', 'org.gnome.gedit.desktop', 'firefox.desktop', 'update-manager.desktop', 'gnome-control-center.desktop']"
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
  gsettings set org.gnome.shell.extensions.dash-to-dock click-action minimize

  echo -e "\n****************************************\n"
  echo "  Configuring terminal theme"
  echo -e "\n****************************************\n"

  profile=$(gsettings get org.gnome.Terminal.ProfilesList default | xargs)
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ default-size-rows 30
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ default-size-columns 120
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ font 'Hack Nerd Font 12'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-system-font false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-theme-colors false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ background-color '#0D0D17'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ foreground-color '#E6E5E5'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ palette "['#4D4D4D', '#F12D52', '#09CD7E', '#F5F17A', '#3182E0', '#FF2B6D', '#09C87A', '#FCFCFC', '#808080', '#F16D86', '#0AE78D', '#FFFC67', '#6096FF', '#FF78A2', '#0AE78D', '#FFFFFF']"
}

vsCodeConfig() {
  echo -e "\n****************************************\n"
  echo "  Installing VS Code extensions"
  echo -e "\n****************************************\n"

  #remove whitespace from list
  sed -i 's/[[:space:]]*$//' ~/files/code_extensions.list
  cat ~/files/code_extensions.list | xargs -L 1 code --install-extension
  rm ~/files/code_extensions.list

  echo -e "\n****************************************\n"
  echo "  Copying VS Code settings"
  echo -e "\n****************************************\n"

  mkdir -p ~/.config/Code/User
  mv ~/files/settings.json ~/.config/Code/User/settings.json
}

changePassword() {
  echo -e "\n****************************************\n"
  echo "  Implementing password change prompt"
  echo -e "\n****************************************\n"

  echo $PASSWORD | sudo -S mkdir -p /usr/local/scripts
  echo $PASSWORD | sudo -S mv ~/files/passwd.sh /usr/local/scripts/passwd.sh
  echo $PASSWORD | sudo -S sed -i -e 's/\r$//' /usr/local/scripts/passwd.sh
  echo $PASSWORD | sudo -S chmod +x /usr/local/scripts/passwd.sh
  cat <<EOF > ~/files/change_password.desktop
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
  echo $PASSWORD | sudo -S mv /etc/xdg/autostart/gnome-initial-setup-first-login.desktop /etc/xdg/autostart/gnome-initial-setup-first-login.desktop.old
  echo $PASSWORD | sudo -S mv ~/files/change_password.desktop /etc/xdg/autostart/change_password.desktop
  rm -Rf ~/files
}

reboot() {
  echo -e "\n****************************************\n"
  echo "  Rebooting"
  echo -e "\n****************************************\n"
  
  echo $PASSWORD | sudo -S reboot
}

main() {
  validateArguments
  
  basePackages

  fonts
  
  vsCode
  
  docker
  
  node
  
  aws
  
  cli

  hashicorp
  
  gnomeConfig
  
  vsCodeConfig
  
  changePassword
  
  reboot
}

main
