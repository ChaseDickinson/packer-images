#!/bin/bash

#pause before beginning install
sleep 10

#install prerequisites for bionic
if [ "$OS_NICKNAME" == "bionic" ];
then
    echo -e '\n ... Installing prerequirements for Bionic ... \n'
    echo $PASSWORD | sudo -S apt-get install -y xorg-video-abi-23 xserver-xorg-core
    echo $PASSWORD | sudo -S apt-get install -y xorgxrdp
fi

#microsoft linux-vm-tools
echo -e '\n ... Installing Microsoft Linux-VM-Tools ... \n'
wget https://raw.githubusercontent.com/Microsoft/linux-vm-tools/master/ubuntu/18.04/install.sh
chmod +x install.sh
echo $PASSWORD | sudo -S ./install.sh
rm install.sh