#!/bin/bash -eux

# --------------------------------------------------------------------------------
# Configure Ubuntu desktop environment
# --------------------------------------------------------------------------------
gnomeConfig() {
  # Configuring GNOME settings
  gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'code.desktop', 'virtualbox.desktop', 'org.gnome.gedit.desktop', 'firefox.desktop', 'gnome-control-center.desktop']"
  gsettings set org.gnome.desktop.session idle-delay 0
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
  gsettings set org.gnome.shell.extensions.dash-to-dock click-action minimize

  # Configuring terminal theme
  profile=$(gsettings get org.gnome.Terminal.ProfilesList default | xargs)
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ default-size-rows 30
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ default-size-columns 120
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ font 'FiraCode Nerd Font Mono 14'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ use-system-font false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ use-theme-colors false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ background-color '#2E3440'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ foreground-color '#E5E9F0'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${profile}"/ palette "['#2E3440', '#88C0D0', '#BF616A', '#5E81AC', '#EBCB8B', '#A3BE8C', '#D08770', '#E5E9F0', '#4C566A', '#88C0D0', '#BF616A', '#5E81AC', '#EBCB8B', '#A3BE8C', '#D08770', '#8FBCBB']"

  # Suppress Welcome Wizard
  touch "${HOME}"/.config/gnome-initial-setup-done
}

vsCodeConfig() {
  # Installing VS Code extensions
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
  # Installing Oh-My-Zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

loadDotfiles() {
  # Cloning dotfile repo
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