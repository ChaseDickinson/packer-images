#!/bin/bash

#pause before beginning install
sleep 10

#microsoft linux-vm-tools
echo -e '\n- Installing Microsoft Linux-VM-Tools ... \n'
wget https://raw.githubusercontent.com/Microsoft/linux-vm-tools/master/ubuntu/18.04/install.sh
chmod +x install.sh
echo $PASSWORD | sudo -S ./install.sh
rm install.sh

#install homebrew, pt II
#echo -e '\n- Installing Homebrew ... \n'
#yes | brew --help

#install awscli
echo -e '\n- Installing AWS CLI ... \n'
pip3 install awscli --upgrade --user

#setting PATH variables
echo -e '\n- Setting PATH variables ... \n'
echo 'export PATH=/bin:$PATH' >>~/.bashrc
echo 'export PATH=~/.local/bin:$PATH' >>~/.bashrc
#echo 'PATH=/home/linuxbrew/.linuxbrew/Homebrew/Library/Homebrew/vendor/portable-ruby/current/bin:$PATH' >>~/.bashrc
#test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
#test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
#test -r ~/.bashrc && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bashrc
#echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

#install aws sam
#echo -e '\n- Installing AWS SAM ... \n'
#brew tap aws/tap
#brew install aws-sam-cli