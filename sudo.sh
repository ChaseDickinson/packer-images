#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

#pause before beginning install
sleep 10

#install latest updates available
echo -e '\n- Installing Latest Upgrades ... \n'
sudo apt update -qq
sudo apt upgrade -qq -y

#install GUI
echo -e '\n- Installing GUI ... \n'
sudo apt install gdm3 -qq -y
sudo apt install --no-install-recommends ubuntu-desktop -qq -y

#firefox
echo -e '\n ...  Installing Firefox ... \n'
sudo apt install firefox -qq -y

#git
echo -e '\n- Installing GIT ... \n'
sudo apt install git -qq -y

#VS Code
echo -e '\n- Installing VS Code ... \n'
sudo snap install --classic code

#pip3 & awscli
echo -e '\n- Installing pip3 ... \n'
sudo apt install python3-pip -qq -y

#docker prerequirements
echo -e '\n- Installing Docker Prerequirements ... \n'
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -qq -y

#add docker repository
echo -e '\n- Adding Docker Repository ... \n'
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#install docker
echo -e '\n- Installing Docker ... \n'
sudo apt update -qq
sudo apt install docker-ce docker-ce-cli containerd.io -qq -y

#install homebrew, pt I
echo -e '\n- Installing Homebrew ... \n'
sudo apt install linuxbrew-wrapper -qq -y

#reboot
sudo reboot