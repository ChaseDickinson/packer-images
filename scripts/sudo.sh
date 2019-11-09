#!/bin/bash

#pause before beginning install
sleep 10

#install latest updates available
echo -e '\n ... Installing Latest Updates ... \n'
echo $PASSWORD | sudo -S apt-get update -qq
echo $PASSWORD | sudo -S apt-get install -qq -y

#install base packages
echo -e '\n ... Installing base packages ... \n'
echo $PASSWORD | sudo -S apt-get install -qq -y gdm3 ubuntu-desktop git python3-pip apt-transport-https ca-certificates curl gnupg-agent software-properties-common

#VS Code
echo -e '\n ... Installing VS Code ... \n'
echo $PASSWORD | sudo -S snap install --classic code

#add docker repository
if [ "$OS_NICKNAME" == "eoan" ];
then
    echo -e '\n ... Skipping Docker Repository ... \n'
else
    echo -e '\n ... Adding Docker Repository ... \n'
    echo $PASSWORD | curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo -S apt-key add -
    echo $PASSWORD | sudo -S add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
fi

#install docker
if [ "$OS_NICKNAME" == "eoan" ];
then
    echo -e '\n ... Skipping Docker Install ... \n'
else
    echo -e '\n ... Installing Docker ... \n'
    echo $PASSWORD | sudo -S apt-get update -qq
    echo $PASSWORD | sudo -S apt-get install -qq -y docker-ce docker-ce-cli containerd.io
fi

#install homebrew, pt I
if [ "$OS_NICKNAME" == "eoan" ];
then
    echo -e '\n ... Skipping Homebrew Install ... \n'
else
    echo -e '\n ... Installing Homebrew ... \n'
    echo $PASSWORD | sudo -S apt-get install linuxbrew-wrapper -qq -y
fi

#install latest updates available
echo -e '\n ... Installing Latest Upgrades ... \n'
echo $PASSWORD | sudo -S apt-get update -qq
echo $PASSWORD | sudo -S apt-get upgrade -qq -y
echo $PASSWORD | sudo -S apt-get dist-upgrade -qq -y

#TODO: Test these commands/behavior from a clean image, then implement after the kernel upgrade
#removing GRUB timeout
#echo -e '\n ... Configuring GRUB ... \n'
#echo $PASSWORD | echo GRUB_TIMEOUT=0 | sudo -S tee -a /etc/default/grub
#echo $PASSWORD | echo GRUB_HIDDEN_TIMEOUT=0 | sudo -S tee -a /etc/default/grub
#echo $PASSWORD | sudo -S update-grub

#reboot
echo -e '\n ... Rebooting ... \n'
echo $PASSWORD | sudo -S reboot