#!/bin/bash

#pause before beginning install
sleep 10

#TODO: figure out why this throws a "no such file or directory" error
#remove unwanted applications
echo -e '\n ... Uninstalling Bloat ... \n'
echo $PASSWORD | cat "$OS_NICKNAME".txt | sudo -S xargs apt-get remove --purge -qq -y

#reboot
echo -e '\n ... Rebooting ... \n'
echo $PASSWORD | sudo -S reboot