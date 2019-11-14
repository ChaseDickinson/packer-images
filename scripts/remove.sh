#!/bin/bash

#pause before beginning install
sleep 10

#remove unwanted applications
echo -e '\n ... Uninstalling Bloat ... \n'
#remove whitespace from list
sed -i 's/[[:space:]]*$//' ~/remove.list
#echo $PASSWORD | sudo -S apt-get remove --purge -qq -y $(cat ~/remove.list)
echo $PASSWORD | sudo -S apt-get remove --purge -y $(cat ~/remove.list)
rm ~/remove.list
#echo $PASSWORD | sudo -S apt-get autoremove -qq -y
echo $PASSWORD | sudo -S apt-get autoremove -y

#add settings back
echo -e '\n ... Reinstalling Settings ... \n'
#echo $PASSWORD | sudo -S apt-get install --no-install-recommends -qq -y gnome-control-center
echo $PASSWORD | sudo -S apt-get install --no-install-recommends -y gnome-control-center

#reboot
echo -e '\n ... Rebooting ... \n'
echo $PASSWORD | sudo -S reboot