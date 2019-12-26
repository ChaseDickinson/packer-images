#!/bin/bash

#pause before beginning install
sleep 10

#install base packages
echo -e '\n ... Installing base packages ... \n'
echo $PASSWORD | sudo -S apt-get install -y git python3-pip apt-transport-https ca-certificates curl gnupg-agent software-properties-common

#install node
echo -e '\n ... Installing Node.js v12 ... \n'
echo $PASSWORD | curl -sL https://deb.nodesource.com/setup_12.x | sudo -S -E bash -
echo $PASSWORD | sudo -S apt-get install -y nodejs

#add docker repository
if [ "$OS_NAME" == "eoan" ];
then
    echo -e '\n ... Skipping Docker Repository ... \n'
else
    echo -e '\n ... Adding Docker Repository ... \n'
    echo $PASSWORD | curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo -S apt-key add -
    echo $PASSWORD | sudo -S add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
fi

#install docker
if [ "$OS_NAME" == "eoan" ];
then
    echo -e '\n ... Skipping Docker Install ... \n'
else
    echo -e '\n ... Installing Docker ... \n'
    echo $PASSWORD | sudo -S apt-get update
    echo $PASSWORD | sudo -S apt-get install -y docker-ce docker-ce-cli containerd.io
fi

#install homebrew
if [ "$OS_NAME" == "eoan" ];
then
    echo -e '\n ... Skipping Homebrew Install ... \n'
else
    echo -e '\n ... Installing Homebrew ... \n'
    echo $PASSWORD | sudo -S apt-get install -y linuxbrew-wrapper
    yes | brew --help
fi

#install awscli
echo -e '\n ... Installing AWS CLI ... \n'
pip3 install awscli --upgrade --user

#setting PATH variables
echo -e '\n ... Setting PATH for AWS CLI ... \n'
echo 'export PATH=/bin:$PATH' >>~/.bashrc
if [ "$OS_NAME" == "eoan" ];
then
    echo -e '\n ... Skipping Setting PATH for Homebrew ... \n'
else
    echo -e '\n ... Setting PATH for Homebrew ... \n'
    echo 'export PATH=~/.local/bin:$PATH' >>~/.bashrc
    echo 'PATH=/home/linuxbrew/.linuxbrew/Homebrew/Library/Homebrew/vendor/portable-ruby/current/bin:$PATH' >>~/.bashrc
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bashrc && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bashrc
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile  
fi

#install aws sam
if [ "$OS_NAME" == "eoan" ];
then
    echo -e '\n ... Skipping AWS SAM Install ... \n'
else
    echo -e '\n ... Installing AWS SAM ... \n'
    brew tap aws/tap
    brew install aws-sam-cli
fi

#forcing user to change password
echo -e '\n ... Setting Password to Expire ... \n'
echo $PASSWORD | sudo -S chage -M 0 $USERNAME

#final cleanup
echo -e '\n ... Autoremove ... \n'
echo $PASSWORD | sudo -S apt-get update
echo $PASSWORD | sudo -S apt-get autoremove -y

#reboot
echo -e '\n ... Rebooting ... \n'
echo $PASSWORD | sudo -S reboot