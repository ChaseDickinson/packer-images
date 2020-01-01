#!/bin/bash

#pause before beginning install
sleep 10

#removing snapd
echo -e '\n ... Removing snapd ... \n'
echo $PASSWORD | sudo -S apt-get remove -y --purge snapd

#install latest updates available
echo -e '\n ... Installing Latest Upgrades ... \n'
echo $PASSWORD | sudo -S apt-get update
echo $PASSWORD | sudo -S apt-get dist-upgrade -y

#running autoremove to clean up outdated dependencies
echo -e '\n ... Removing outdated dependencies ... \n'
echo $PASSWORD | sudo -S apt-get autoremove -y

#reinstalling snapd
echo -e '\n ... Reinstalling snapd ... \n'
echo $PASSWORD | sudo -S apt-get install -y snapd

#create a working directory
mkdir ~/wip

#reboot
echo -e '\n ... Rebooting ... \n'
echo $PASSWORD | sudo -S reboot