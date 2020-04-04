#!/bin/bash

# ----------------------------------------
# Configure Ubuntu desktop environment
# ----------------------------------------
set -o errexit
set -o errtrace
set -o nounset

validateArguments() {
  if [ -z "${PASSWORD-}" ]; then
    printf "\n\nError: 'PASSWORD' is required.\n\n"
    exit 1
  fi
}

basePackages() {
  #install latest updates available
  echo -e '\n****************************************\n'
  echo '  Installing base packages'
  echo -e '\n****************************************\n'
  echo $PASSWORD | sudo -S apt-get install -y \
  git \
  python3-pip \
  apt-transport-https \
  ca-certificates curl \
  gnupg-agent \
  software-properties-common \
  powerline \
  fonts-firacode
}

vsCode() {
  echo -e '\n****************************************\n'
  echo '  Installing Visual Studio Code'
  echo -e '\n****************************************\n'
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  echo $PASSWORD | sudo -S install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  echo $PASSWORD | sudo -S sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  echo $PASSWORD | sudo -S apt-get update
  echo $PASSWORD | sudo -S apt-get install -y code 
  rm packages.microsoft.gpg
}

docker() {
  echo -e '\n****************************************\n'
  echo '  Installing Docker'
  echo -e '\n****************************************\n'
  # Adding Docker repo    
  echo $PASSWORD | curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo -S apt-key add -
  echo $PASSWORD | sudo -S add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  # Installing Docker
  echo $PASSWORD | sudo -S apt-get update
  echo $PASSWORD | sudo -S apt-get install -y docker-ce docker-ce-cli containerd.io
}

node() {
  echo -e '\n****************************************\n'
  echo '  Installing Node'
  echo -e '\n****************************************\n'
  echo $PASSWORD | curl -sL https://deb.nodesource.com/setup_12.x | sudo -S -E bash -
  echo $PASSWORD | sudo -S apt-get install -y nodejs
}

aws() {
  echo -e '\n****************************************\n'
  echo '  Installing AWS CLI'
  echo -e '\n****************************************\n'
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  echo $PASSWORD | sudo -S ./aws/install
  rm -rf aws
  rm awscliv2.zip
}

path() {
  echo -e '\n****************************************\n'
  echo '  Setting PATH variables'
  echo -e '\n****************************************\n'
  #awscli
  echo 'export PATH=/bin:$PATH' >>~/.bashrc
  #powerline
  echo -e "\n\n#powerline configuration" >>~/.bashrc
  echo "if [ -f $(which powerline-daemon) ]; then" >>~/.bashrc
  echo -e "\tpowerline-daemon -q" >>~/.bashrc
  echo -e "\tPOWERLINE_BASH_CONTINUATION=1" >>~/.bashrc
  echo -e "\tPOWERLINE_BASH_SELECT=1" >>~/.bashrc
  echo -e "\t. /usr/share/powerline/bindings/bash/powerline.sh" >>~/.bashrc
  echo "fi" >>~/.bashrc
}

hashicorp() {
  echo -e '\n****************************************\n'
  echo '  Install Terraform'
  echo -e '\n****************************************\n'
  curl "https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip" -o "terraform.zip"
  unzip terraform.zip
  echo $PASSWORD | sudo -S mv terraform /usr/bin/terraform
  rm terraform.zip

  echo -e '\n****************************************\n'
  echo '  Install Packer'
  echo -e '\n****************************************\n'
  curl "https://releases.hashicorp.com/packer/1.5.1/packer_1.5.1_linux_amd64.zip" -o "packer.zip"
  unzip packer.zip
  echo $PASSWORD | sudo -S mv packer /usr/bin/packer
  rm packer.zip
}

gnomeConfig() {
  echo -e '\n****************************************\n'
  echo '  Configuring desktop favorites'
  echo -e '\n****************************************\n'
  gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'code.desktop', 'org.gnome.gedit.desktop', 'firefox.desktop', 'update-manager.desktop', 'gnome-control-center.desktop']"
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
  gsettings set org.gnome.shell.extensions.dash-to-dock click-action minimize

  echo -e '\n****************************************\n'
  echo '  Configuring terminal theme'
  echo -e '\n****************************************\n'
  profile=$(gsettings get org.gnome.Terminal.ProfilesList default | xargs)
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ default-size-rows 30
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ default-size-columns 120
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ font 'Fira Code 12'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-system-font false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-theme-colors false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ background-color '#1c262b'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ foreground-color '#c2c8d7'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ palette "['#000000', '#EE2B2A', '#40A33F', '#FFEA2E', '#1E80F0', '#8800A0', '#16AFCA', '#A4A4A4', '#777777', '#DC5C60', '#70BE71', '#FFF163', '#54A4F3', '#AA4DBC', '#42C7DA', '#FFFFFF']"
}

vsCodeConfig() {
  echo -e '\n****************************************\n'
  echo '  Installing VS Code extensions'
  echo -e '\n****************************************\n'
  #remove whitespace from list
  sed -i 's/[[:space:]]*$//' ~/files/code_extensions.list
  cat ~/files/code_extensions.list | xargs -L 1 code --install-extension
  rm ~/files/code_extensions.list
  echo -e '\n****************************************\n'
  echo '  Copying VS Code settings'
  echo -e '\n****************************************\n'
  mkdir -p ~/.config/Code/User
  mv ~/files/settings.json ~/.config/Code/User/settings.json
}

changePassword() {
  echo -e '\n****************************************\n'
  echo '  Implementing password change prompt'
  echo -e '\n****************************************\n'
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
  rm -rf ~/files
}

reboot() {
  echo -e '\n****************************************\n'
  echo '  Rebooting'
  echo -e '\n****************************************\n'
  echo $PASSWORD | sudo -S reboot
}

main() {
  validateArguments
  
  basePackages
  
  vsCode
  
  docker
  
  node
  
  aws
  
  path
  
  hashicorp
  
  gnomeConfig
  
  vsCodeConfig
  
  changePassword
  
  reboot
}

main
