#!/bin/bash -eux

# --------------------------------------------------------------------------------
# Configure Ubuntu desktop environment
# --------------------------------------------------------------------------------
gnomeConfig() {
  echo "****************************************"
  echo "  Configuring GNOME settings"
  echo "****************************************"

  gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'code.desktop', 'virtualbox.desktop', 'org.gnome.gedit.desktop', 'firefox.desktop', 'gnome-control-center.desktop']"
  gsettings set org.gnome.desktop.session idle-delay 0
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
  gsettings set org.gnome.shell.extensions.dash-to-dock click-action minimize

  echo "****************************************"
  echo "  Configuring terminal theme"
  echo "****************************************"

  profile=$(gsettings get org.gnome.Terminal.ProfilesList default | xargs)
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ default-size-rows 30
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ default-size-columns 120
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ font 'Hack Nerd Font 14'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ use-system-font false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ use-theme-colors false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ background-color '#0D0D17'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ foreground-color '#E6E5E5'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ palette "['#17384C', '#D15123', '#027C9B', '#FCA02F', '#1E4950', '#68D4F1', '#50A3B5', '#DEB88D', '#434B53', '#D48678', '#628D98', '#FDD39F', '#1BBCDD', '#BBE3EE', '#87ACB4', '#FEE4CE']"

  echo "****************************************"
  echo "  Suppress Welcome Wizard"
  echo "****************************************"
  touch "${HOME}"/.config/gnome-initial-setup-done
}

vsCodeConfig() {
  echo "****************************************"
  echo "  Installing VS Code extensions"
  echo "****************************************"

  ext_list=(\
    amazonwebservices.aws-toolkit-vscode \
    chef-software.chef \
    coenraads.bracket-pair-colorizer-2 \
    github.github-vscode-theme \
    eamodio.gitlens \
    esbenp.prettier-vscode \
    ms-azuretools.vscode-docker \
    ms-vscode-remote.remote-containers \
    ms-vscode-remote.remote-ssh \
    oderwat.indent-rainbow \
    wayou.vscode-todo-highlight)

  for i in "${ext_list[@]}"
  do
    echo "Installing VS Code extension: ${i}"
    code --install-extension "${i}"
  done
}

omz() {
  echo "****************************************"
  echo "  Installing Oh-My-Zsh"
  echo "****************************************"

  # Oh-My-Zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

loadDotfiles() {
  echo "****************************************"
  echo "  Cloning dotfile repo"
  echo "****************************************"

  cd "${HOME}"
  git clone https://github.com/ChaseDickinson/dotfiles.git .dotfiles
  cd .dotfiles
  chmod +x install.sh
  ./install.sh
}

main() {
  gnomeConfig

  vsCodeConfig

  omz

  loadDotfiles
}

main