#!/bin/bash

#pause before beginning install
sleep 10

#install prerequisites for bionic
if [ "$OS_NICKNAME" == "bionic" ];
then
    echo -e '\n ... Installing prerequirements for Bionic ... \n'
    echo $PASSWORD | sudo -S apt-get install -y xserver-xorg-core
    echo $PASSWORD | sudo -S apt-get install -y xserver-xorg-input-all
fi

#microsoft linux-vm-tools
echo -e '\n ... Installing Microsoft Linux-VM-Tools ... \n'
wget https://raw.githubusercontent.com/Microsoft/linux-vm-tools/master/ubuntu/18.04/install.sh
sed -i 's/apt/apt-get/g' install.sh
chmod +x install.sh
echo $PASSWORD | sudo -S ./install.sh
rm install.sh

#final cleanup
echo -e '\n ... Autoremove ... \n'
echo $PASSWORD | sudo -S apt-get update
echo $PASSWORD | sudo -S apt-get autoremove -y
