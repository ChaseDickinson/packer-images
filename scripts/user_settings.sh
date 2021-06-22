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
  git clone https://github.com/ChaseDickinson/dotfiles.git .dotfiles

  echo -e "\n****************************************\n"
  echo "  Ensure directories are created"
  echo -e "\n****************************************\n"
  if [ ! -d "${HOME}"/.config/Code/User ]; then
    mkdir -p "${HOME}"/.config/Code/User
    echo "VS Code config directory created."
  else
    echo "VS Code config directory already exists."
  fi

  if [ ! -d "${HOME}"/.oh-my-zsh/custom ]; then
    mkdir "${HOME}"/.oh-my-zsh/custom
    echo "OMZ custom directory created."
  else
    echo "OMZ custom directory already exists."
  fi

  echo -e "\n****************************************\n"
  echo "  Creating symlinks"
  echo -e "\n****************************************\n"
  # VS Code
  ln -sv "${HOME}"/.dotfiles/vscode_settings.json "${HOME}"/.config/Code/User/settings.json

  # Zsh profile
  if [ -f "${HOME}"/.zshrc ]; then
    rm "${HOME}"/.zshrc
  fi

  ln -sv "${HOME}"/.dotfiles/.zshrc "${HOME}"/.zshrc

  # omz aliases
  ln -sv "${HOME}"/.dotfiles/aliases.zsh "${HOME}"/.oh-my-zsh/custom/aliases.zsh

  # omz functions
  ln -sv "${HOME}"/.dotfiles/functions.zsh "${HOME}"/.oh-my-zsh/custom/functions.zsh

  # omz theme
  ln -sv "${HOME}"/.dotfiles/okie_chase.zsh-theme "${HOME}"/.oh-my-zsh/custom/themes/okie_chase.zsh-theme
}

main() {
  gnomeConfig

  vsCodeConfig

  omz

  loadDotfiles
}

main