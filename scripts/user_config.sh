#!/bin/bash

#pause before beginning install
sleep 10

#configure favorites bar
echo -e '\n ... Configuring favorites ... \n'
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'code.desktop', 'org.gnome.gedit.desktop', 'org.gnome.Nautilus.desktop', 'update-manager.desktop', 'gnome-control-center.desktop']"

#TODO:
#  download preferred font
#  extract to appropriate directory
#  run fc-cache -fv command
#  update VS code settings to use preferred font settings

#install code extensions
echo -e '\n ... Installing VS Code extensions ... \n'
#remove whitespace from list
sed -i 's/[[:space:]]*$//' ~/files/code_extensions.list
cat ~/files/code_extensions.list | xargs -L 1 code --install-extension
rm ~/files/code_extensions.list

#pause before configuring settings
sleep 10

#vs code settings
echo -e '\n ... Copying VS Code settings ... \n'
mkdir -p ~/.config/Code/User
mv ~/files/settings.json ~/.config/Code/User/settings.json
rm -rf ~/files

#forcing user to change password
echo -e '\n ... Setting Password to Expire Today ... \n'
echo $PASSWORD | sudo -S chage -M 0 $USERNAME
