#!/bin/bash

# --------------------------------------------------------------------------------
# Configure Ubuntu desktop environment
# --------------------------------------------------------------------------------
set -o errexit
set -o errtrace
set -o nounset

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

  echo -e "\n****************************************\n"
  echo "  Suppress Welcome Wizard"
  echo -e "\n****************************************\n"
  touch "${HOME}"/.config/gnome-initial-setup-done
}

vsCodeConfig() {
  echo -e "\n****************************************\n"
  echo "  Installing VS Code extensions"
  echo -e "\n****************************************\n"

  #remove whitespace from list
  sed -i 's/[[:space:]]*$//' /tmp/files/code_extensions.list
  < /tmp/files/code_extensions.list xargs -L 1 code --install-extension
  rm -Rf /tmp/files
}

omz() {
  echo -e "\n****************************************\n"
  echo "  Installing Oh-My-Zsh"
  echo -e "\n****************************************\n"

  # Oh-My-Zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

loadDotfiles() {
  echo -e "\n****************************************\n"
  echo "  Cloning dotfile repo"
  echo -e "\n****************************************\n"

  cd "${HOME}"
  git clone https://github.com/ChaseDickinson/dotfiles.git

  echo -e "\n****************************************\n"
  echo "  Ensure directories are created"
  echo -e "\n****************************************\n"
  mkdir -p "${HOME}"/.config/Code/User
  mkdir "${HOME}"/.oh-my-zsh/custom
  
  echo -e "\n****************************************\n"
  echo "  Configuring VS Code settings"
  echo -e "\n****************************************\n"
  mv "${HOME}"/dotfiles/vscode_settings.json "${HOME}"/.config/Code/User/settings.json
  ln -sv "${HOME}"/.config/Code/User/settings.json "${HOME}"/dotfiles/vscode_settings.json

  echo -e "\n****************************************\n"
  echo "  Configuring Zsh profile"
  echo -e "\n****************************************\n"
  if [ -f "${HOME}"/.zshrc ]; then
    rm "${HOME}"/.zshrc
  fi

  mv "${HOME}"/dotfiles/.zshrc "${HOME}"/.zshrc
  ln -sv "${HOME}"/.zshrc "${HOME}"/dotfiles/.zshrc

  echo -e "\n****************************************\n"
  echo "  Configuring Zsh aliases"
  echo -e "\n****************************************\n"
  mv "${HOME}"/dotfiles/aliases.zsh "${HOME}"/.oh-my-zsh/custom/aliases.zsh
  ln -sv "${HOME}"/.oh-my-zsh/custom/aliases.zsh "${HOME}"/dotfiles/aliases.zsh

  echo -e "\n****************************************\n"
  echo "  Configuring Zsh functions"
  echo -e "\n****************************************\n"
  mv "${HOME}"/dotfiles/functions.zsh "${HOME}"/.oh-my-zsh/custom/functions.zsh
  ln -sv "${HOME}"/.oh-my-zsh/custom/functions.zsh "${HOME}"/dotfiles/functions.zsh
}

main() {
  gnomeConfig

  vsCodeConfig

  omz

  loadDotfiles
}

main