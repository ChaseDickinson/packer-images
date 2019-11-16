#!/bin/bash

#pause before beginning install
sleep 10

#remove unwanted applications
echo -e '\n ... Uninstalling Bloat ... \n'
#remove whitespace from list
sed -i 's/[[:space:]]*$//' ~/remove.list
echo $PASSWORD | sudo -S apt-get remove --purge -qq -y $(cat ~/remove.list)
rm ~/remove.list

#add settings back
echo -e '\n ... Reinstalling Settings ... \n'
echo $PASSWORD | sudo -S apt-get install --no-install-recommends -qq -y gnome-control-center

#remove unnecessary dependencies
echo -e '\n ... Uninstalling Dependencies ... \n'
echo $PASSWORD | sudo -S apt-get update -qq
echo $PASSWORD | sudo -S apt-get autoremove -qq -y

#reboot
echo -e '\n ... Rebooting ... \n'
echo $PASSWORD | sudo -S reboot