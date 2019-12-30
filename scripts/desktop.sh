#!/bin/bash

#pause before beginning install
sleep 10

#install base packages
echo -e '\n ... Installing base packages ... \n'
echo $PASSWORD | sudo -S apt-get install -y git python3-pip apt-transport-https ca-certificates curl gnupg-agent software-properties-common

#VS Code
echo -e '\n ... Installing VS Code ... \n'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
echo $PASSWORD | sudo -S install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
echo $PASSWORD | sudo -S sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
echo $PASSWORD | sudo -S apt-get update
echo $PASSWORD | sudo -S apt-get install -y code 
rm packages.microsoft.gpg

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

#configure favorites bar
echo -e '\n ... Configuring favorites ... \n'
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'code.desktop', 'org.gnome.gedit.desktop', 'org.gnome.Nautilus.desktop', 'update-manager.desktop', 'gnome-control-center.desktop']"

#install code extensions
echo -e '\n ... Installing VS Code extensions ... \n'
#remove whitespace from list
sed -i 's/[[:space:]]*$//' ~/files/code_extensions.list
cat ~/files/code_extensions.list | xargs -L 1 code --install-extension
rm ~/files/code_extensions.list

#pause before configuring settings
sleep 10

#vs code settings
echo -e '\n ... Copying VS Code settings ... \n'
mkdir -p ~/.config/Code/User
mv ~/files/settings.json ~/.config/Code/User/settings.json

#implementing prompt to change password on first login
#TODO: update to rename default .desktop file; copy new one
echo -e '\n ... Implementing Password Change Prompt ... \n'
echo $PASSWORD | sudo -S mkdir -p /usr/local/scripts
echo $PASSWORD | sudo -S mv ~/files/passwd.sh /usr/local/scripts/passwd.sh
rm -rf ~/files
echo $PASSWORD | sudo -S sed -i -e 's/\r$//' /usr/local/scripts/passwd.sh
echo $PASSWORD | sudo -S chmod +x /usr/local/scripts/passwd.sh
echo $PASSWORD | sudo -S sed -i 's/Exec=.*/Exec=gnome-terminal -e "bash -c \/usr\/local\/scripts\/passwd.sh;bash"/' /etc/xdg/autostart/gnome-initial-setup-first-login.desktop

#reboot
echo -e '\n ... Rebooting ... \n'
echo $PASSWORD | sudo -S reboot