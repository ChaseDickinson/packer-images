#!/bin/bash

#pause before beginning install
sleep 10

#configure favorites bar
echo -e '\n ... Configuring favorites ... \n'
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'code_code.desktop', 'org.gnome.gedit.desktop', 'org.gnome.Nautilus.desktop', 'update-manager.desktop', 'gnome-control-center.desktop']"

#install code extensions
#code --install-extension amazonwebservices.aws-toolkit-vscode
#code --install-extension equinusocio.vsc-material-theme
#code --install-extension pkief.material-icon-theme
#code --install-extension ms-azuretools.vscode-docker

#vs code settings
#echo 'export PATH=~/.local/bin:$PATH' >>~/.bashrc
#echo 'export "workbench.colorTheme": "Material Theme Darker"' >>~/.config/Code/User/settings.json
#echo 'export "materialTheme.accent": "Orange"'  >>~/.config/Code/User/settings.json

#forcing user to change password
#echo -e '\n ... Requiring user to set a new password at next login ... \n'
#echo $PASSWORD | sudo -S charge --lastday 0 ubuntu