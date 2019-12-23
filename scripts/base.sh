#!/bin/bash

#pause before beginning install
sleep 10

#install latest updates available
echo -e '\n ... Installing Latest Updates ... \n'
echo $PASSWORD | sudo -S apt-get update -qq
echo $PASSWORD | sudo -S apt-get upgrade -qq -y
echo $PASSWORD | sudo -S apt-get dist-upgrade -qq -y
echo $PASSWORD | sudo -S apt-get autoremove -qq -y

#reboot
echo -e '\n ... Rebooting ... \n'
echo $PASSWORD | sudo -S reboot