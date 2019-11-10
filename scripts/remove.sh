#!/bin/bash

#pause before beginning install
sleep 10

#remove unwanted applications
echo -e '\n ... Uninstalling Bloat ... \n'
sed -i 's/[[:space:]]*$//' ~/remove.txt
echo $PASSWORD | sudo -S apt-get remove --purge -qq -y $(cat ~/remove.txt)
rm ~/remove.txt
echo $PASSWORD | sudo -S apt-get autoremove -qq -y

#add settings back
echo -e '\n ... Reinstalling Settings ... \n'
echo $PASSWORD | sudo -S apt-get install -qq -y gnome-control-center

#TODO: Disable welcome message

#reboot
echo -e '\n ... Rebooting ... \n'
echo $PASSWORD | sudo -S reboot