#!/bin/bash

#pause before beginning install
sleep 10

#install latest updates available
echo -e '\n ...  Installing Latest Upgrades ... \n'
echo $PASSWORD | sudo -S DEBIAN_FRONTEND=noninteractive apt update -qq
echo $PASSWORD | sudo -S DEBIAN_FRONTEND=noninteractive apt upgrade -qq -y

#reboot
echo $PASSWORD | sudo reboot

#pause before beginning install
sleep 30

#microsoft linux-vm-tools
echo -e '\n ...  Installing Microsoft Linux-VM-Tools ... \n'
wget https://raw.githubusercontent.com/Microsoft/linux-vm-tools/master/ubuntu/18.04/install.sh
chmod +x install.sh
echo $PASSWORD | sudo -S ./install.sh
rm install.sh

#install gui
echo -e '\n ...  Installing GUI ... \n'
echo $PASSWORD | sudo -S DEBIAN_FRONTEND=noninteractive apt install gdm3 -qq -y
echo $PASSWORD | sudo -S DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends ubuntu-desktop -qq -y

#firefox
echo -e '\n ...  Installing Firefox ... \n'
echo $PASSWORD | sudo -S DEBIAN_FRONTEND=noninteractive apt install firefox -qq -y

#git
echo -e '\n ...  Installing GIT ... \n'
echo $PASSWORD | sudo -S DEBIAN_FRONTEND=noninteractive apt install git -qq -y

#vs vode
echo -e '\n ...  Installing VS Code ... \n'
sudo snap install --classic code

#pip3 & awscli
echo -e '\n ...  Installing pip3 ... \n'
echo $PASSWORD | sudo -S DEBIAN_FRONTEND=noninteractive apt install python3-pip -qq -y
pip3 install awscli --upgrade --user

#docker prerequirements
echo -e '\n ...  Installing Docker Prerequirements ... \n'
echo $PASSWORD | sudo -S DEBIAN_FRONTEND=noninteractive apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -qq -y

#add docker repository
echo -e '\n ...  Adding Docker Repository ... \n'
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#install docker
echo -e '\n ...  Installing Docker ... \n'
echo $PASSWORD | sudo -S DEBIAN_FRONTEND=noninteractive apt update -qq
echo $PASSWORD | sudo -S DEBIAN_FRONTEND=noninteractive apt install docker-ce docker-ce-cli containerd.io -qq -y

#install homebrew
echo -e '\n ...  Installing Homebrew ... \n'
echo $PASSWORD | sudo -S DEBIAN_FRONTEND=noninteractive apt install linuxbrew-wrapper -qq -y
yes | brew --help

#setting PATH variables
echo -e '\n ...  Setting PATH variables ... \n'
echo 'export PATH=/bin:$PATH' >>~/.bashrc
echo 'export PATH=~/.local/bin:$PATH' >>~/.bashrc
echo 'PATH=/home/linuxbrew/.linuxbrew/Homebrew/Library/Homebrew/vendor/portable-ruby/current/bin:$PATH' >>~/.bashrc
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bashrc && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bashrc
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

#install aws sam
echo -e '\n ...  Installing AWS SAM ... \n'
brew tap aws/tap
brew install aws-sam-cli