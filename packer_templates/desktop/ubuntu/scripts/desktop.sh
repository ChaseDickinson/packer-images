#!/bin/bash -eux

# --------------------------------------------------------------------------------
# Configure Ubuntu desktop environment
# --------------------------------------------------------------------------------
validateArguments() {
  if [ -z "${USERNAME-}" ]; then
    printf "\n\nError: 'USERNAME' is required.\n\n"
    exit 1
  fi
}

fonts() {
  echo "****************************************"
  echo "  Installing fonts"
  echo "****************************************"

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
  echo "****************************************"
  echo "  Installing Visual Studio Code"
  echo "****************************************"
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
  apt-get update
  apt-get install -y code
  rm packages.microsoft.gpg
}

shell() {
  echo "****************************************"
  echo "  Set Zsh as default shell"
  echo "****************************************"
  # Set default shell
  usermod --shell "$(command -v zsh)" "${USERNAME}"
}

main() {
  validateArguments  

  fonts

  vsCode

  shell
}

main
