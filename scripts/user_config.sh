#!/bin/bash

#pause before beginning install
sleep 10

#configure favorites bar
echo -e '\n ... Configuring favorites ... \n'
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'code.desktop', 'org.gnome.gedit.desktop', 'org.gnome.Nautilus.desktop', 'update-manager.desktop', 'gnome-control-center.desktop']"

#install code extensions
code --install-extension amazonwebservices.aws-toolkit-vscode
code --install-extension equinusocio.vsc-material-theme
code --install-extension pkief.material-icon-theme
code --install-extension ms-azuretools.vscode-docker

#pause before configuring settings
sleep 10

#vs code settings
mkdir -p ~/.config/Code/User
cat <<EOF > ~/.config/Code/User/settings.json
{
    "git.autofetch": true,
    "workbench.iconTheme": "material-icon-theme",
    "workbench.colorTheme": "Material Theme Darker",
    "materialTheme.accent": "Orange",
    "aws.samcli.location": "/home/ubuntu/.linuxbrew/bin/sam",
    "aws.telemetry": "Disable"
}
EOF

#forcing user to change password
echo -e '\n ... Setting Password to Expire in a Day ... \n'
echo $PASSWORD | sudo -S chage -M 1 $USERNAME
