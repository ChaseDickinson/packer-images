#!/bin/bash

#pause before beginning install
sleep 60

#install homebrew, pt II
if [ "$OS_NICKNAME" == "eoan" ];
then
    echo -e '\n ... Skipping Homebrew Install ... \n'
else
    echo -e '\n ... Installing Homebrew ... \n'
    yes | brew --help
fi

#install awscli
echo -e '\n ... Installing AWS CLI ... \n'
pip3 install awscli --upgrade --user

#setting PATH variables
echo -e '\n ... Setting PATH for AWS CLI ... \n'
echo 'export PATH=/bin:$PATH' >>~/.bashrc
if [ "$OS_NICKNAME" == "eoan" ];
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
if [ "$OS_NICKNAME" == "eoan" ];
then
    echo -e '\n ... Skipping AWS SAM Install ... \n'
else
    echo -e '\n ... Installing AWS SAM ... \n'
    brew tap aws/tap
    brew install aws-sam-cli
fi

#suppressing welcome message
echo -e '\n ... Suppressing Welcome Message ... \n'
line="Exec=/usr/lib/gnome-initial-setup/gnome-initial-setup --existing-user"
sed -i 's|$line|#$line|' /etc/xdg/autostart/gnome-inital-setup-first-login.desktop

#suppressing upgrade message for disco
if [ "$OS_NICKNAME" == "disco" ];
then
    echo -e '\n ... Suppressing Disco Upgrade ... \n'
    gsettings set com.ubuntu.update-notifier no-show-notifications true    
fi

#configure favorites bar
echo -e '\n ... Configuring favorites ... \n'
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'code_code.desktop', 'org.gnome.Nautilus.desktop', 'update-manager.desktop', 'gnome-control-center.desktop']"