#!/bin/bash

#pause before beginning install
sleep 10

#microsoft linux-vm-tools
echo -e '\n ... Installing Microsoft Linux-VM-Tools ... \n'
wget https://raw.githubusercontent.com/Microsoft/linux-vm-tools/master/ubuntu/18.04/install.sh
chmod +x install.sh
echo $PASSWORD | sudo -S ./install.sh
rm install.sh

#reboot
echo -e '\n ... Rebooting ... \n'
echo $PASSWORD | sudo -S reboot