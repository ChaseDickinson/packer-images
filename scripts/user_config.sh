#!/bin/bash

#pause before beginning install
sleep 10

#configure favorites bar
echo -e '\n ... Configuring favorites ... \n'
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'code_code.desktop', 'org.gnome.gedit.desktop', 'org.gnome.Nautilus.desktop', 'update-manager.desktop', 'gnome-control-center.desktop']"

#install code extensions
code --install-extension amazonwebservices.aws-toolkit-vscode
code --install-extension equinusocio.vsc-material-theme
code --install-extension pkief.material-icon-theme
code --install-extension ms-azuretools.vscode-docker

#pause before configuring settings
sleep 10

#vs code settings
echo -e '\t"workbench.colorTheme": "Material Theme Darker"' >>~/.config/Code/User/settings.json
echo -e '\t"materialTheme.accent": "Orange"'  >>~/.config/Code/User/settings.json
echo -e '\t"workbench.iconTheme": "material-icon-theme"'  >>~/.config/Code/User/settings.json

#forcing user to change password
echo -e '\n ... Setting Password to Expire in a Day ... \n'
echo $PASSWORD | sudo -S chage -M 1 $USERNAME
