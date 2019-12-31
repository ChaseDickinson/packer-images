#!/bin/bash

#pause before beginning install
sleep 10

#install base packages
echo -e '\n ... Installing base packages ... \n'
echo $PASSWORD | sudo -S apt-get install -y \
git \
python3-pip \
apt-transport-https \
ca-certificates curl \
gnupg-agent \
software-properties-common \
powerline \
fonts-firacode

#VS Code
echo -e '\n ... Installing VS Code ... \n'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
echo $PASSWORD | sudo -S install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
echo $PASSWORD | sudo -S sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
echo $PASSWORD | sudo -S apt-get update
echo $PASSWORD | sudo -S apt-get install -y code 
rm packages.microsoft.gpg

#add VirtualBox repository
echo -e '\n ... Installing VirtualBox ... \n'
echo $PASSWORD | wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo -S apt-key add -
echo $PASSWORD | sudo -S add-apt-repository "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"

#install VirtualBox
echo $PASSWORD | sudo -S apt update
echo $PASSWORD | sudo -S apt install -y virtualbox-6.1

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

#install node
echo -e '\n ... Installing Node.js v12 ... \n'
echo $PASSWORD | curl -sL https://deb.nodesource.com/setup_12.x | sudo -S -E bash -
echo $PASSWORD | sudo -S apt-get install -y nodejs

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

echo -e '\n ... Setting PATH for Powerline ... \n'
echo -e "\n\n#powerline configuration" >>~/.bashrc
echo "if [ -f `which powerline-daemon` ]; then" >>~/.bashrc
echo -e "\tpowerline-daemon -q" >>~/.bashrc
echo -e "\tPOWERLINE_BASH_CONTINUATION=1" >>~/.bashrc
echo -e "\tPOWERLINE_BASH_SELECT=1" >>~/.bashrc
echo -e "\t. /usr/share/powerline/bindings/bash/powerline.sh" >>~/.bashrc
echo "fi" >>~/.bashrc

#install awscliv2
echo -e '\n ... Installing AWS CLI v2 ... \n'
curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
echo $PASSWORD | sudo -S ./aws/install
rm -rf aws
rm awscliv2.zip

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
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'code.desktop', 'org.gnome.gedit.desktop', 'virtualbox.desktop', 'firefox.desktop', 'update-manager.desktop', 'gnome-control-center.desktop']"

#theme GNOME terminal
#need a way to capture the UUID of the default profile; or create a new one & set it as the default?
#Current values:
#org.gnome.Terminal.Legacy.Profile audible-bell true
#org.gnome.Terminal.Legacy.Profile cursor-shape 'block'
#org.gnome.Terminal.Legacy.Profile cursor-colors-set false
#org.gnome.Terminal.Legacy.Profile scroll-on-keystroke true
#org.gnome.Terminal.Legacy.Profile cjk-utf8-ambiguous-width 'narrow'
#org.gnome.Terminal.Legacy.Profile default-size-rows 30
#org.gnome.Terminal.Legacy.Profile encoding 'UTF-8'
#org.gnome.Terminal.Legacy.Profile use-theme-colors true
#org.gnome.Terminal.Legacy.Profile custom-command ''
#org.gnome.Terminal.Legacy.Profile visible-name 'Unnamed'
#org.gnome.Terminal.Legacy.Profile text-blink-mode 'always'
#org.gnome.Terminal.Legacy.Profile cell-height-scale 1.0
#org.gnome.Terminal.Legacy.Profile login-shell false
#org.gnome.Terminal.Legacy.Profile exit-action 'close'
#org.gnome.Terminal.Legacy.Profile use-system-font false
#org.gnome.Terminal.Legacy.Profile backspace-binding 'ascii-delete'
#org.gnome.Terminal.Legacy.Profile rewrap-on-resize true
#org.gnome.Terminal.Legacy.Profile foreground-color '#D3D7CF'
#org.gnome.Terminal.Legacy.Profile bold-color-same-as-fg true
#org.gnome.Terminal.Legacy.Profile background-transparency-percent 50
#org.gnome.Terminal.Legacy.Profile cursor-blink-mode 'system'
#org.gnome.Terminal.Legacy.Profile bold-is-bright true
#org.gnome.Terminal.Legacy.Profile default-show-menubar true
#org.gnome.Terminal.Legacy.Profile cell-width-scale 1.0
#org.gnome.Terminal.Legacy.Profile default-size-columns 120
#org.gnome.Terminal.Legacy.Profile palette ['#2E3436', '#CC0000', '#4E9A06', '#C4A000', '#3465A4', '#75507B', '#06989A', '#D3D7CF', '#555753', '#EF2929', '#8AE234', '#FCE94F', '#729FCF', '#AD7FA8', '#34E2E2', '#EEEEEC']
#org.gnome.Terminal.Legacy.Profile cursor-foreground-color '#ffffff'
#org.gnome.Terminal.Legacy.Profile allow-bold true
#org.gnome.Terminal.Legacy.Profile background-color '#2E3436'
#org.gnome.Terminal.Legacy.Profile highlight-foreground-color '#ffffff'
#org.gnome.Terminal.Legacy.Profile font 'Fira Code 15'
#org.gnome.Terminal.Legacy.Profile delete-binding 'delete-sequence'
#org.gnome.Terminal.Legacy.Profile use-theme-transparency true
#org.gnome.Terminal.Legacy.Profile scrollback-unlimited false
#org.gnome.Terminal.Legacy.Profile use-transparent-background false
#org.gnome.Terminal.Legacy.Profile cursor-background-color '#000000'
#org.gnome.Terminal.Legacy.Profile highlight-background-color '#000000'
#org.gnome.Terminal.Legacy.Profile scroll-on-output false
#org.gnome.Terminal.Legacy.Profile scrollbar-policy 'always'
#org.gnome.Terminal.Legacy.Profile use-custom-command false
#org.gnome.Terminal.Legacy.Profile bold-color '#000000'
#org.gnome.Terminal.Legacy.Profile highlight-colors-set false
#org.gnome.Terminal.Legacy.Profile scrollback-lines 10000
#org.gnome.Terminal.Legacy.Profile word-char-exceptions @ms nothing

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
echo -e '\n ... Implementing Password Change Prompt ... \n'
echo $PASSWORD | sudo -S mkdir -p /usr/local/scripts
echo $PASSWORD | sudo -S mv ~/files/passwd.sh /usr/local/scripts/passwd.sh
echo $PASSWORD | sudo -S sed -i -e 's/\r$//' /usr/local/scripts/passwd.sh
echo $PASSWORD | sudo -S chmod +x /usr/local/scripts/passwd.sh
cat <<EOF > ~/files/change_password.desktop
[Desktop Entry]
Name=Change Password
Icon=preferences-system
Comment=Script to change password on first launch
Exec=gnome-terminal -e "bash -c /usr/local/scripts/passwd.sh;bash"
Terminal=false
Type=Application
StartupNotify=true
Categories=GNOME;GTK;System;
OnlyShowIn=GNOME;Unity;
NoDisplay=true
AutostartCondition=unless-exists password-reset-done
EOF
echo $PASSWORD | sudo -S mv /etc/xdg/autostart/gnome-initial-setup-first-login.desktop /etc/xdg/autostart/gnome-initial-setup-first-login.desktop.old
echo $PASSWORD | sudo -S mv ~/files/change_password.desktop /etc/xdg/autostart/change_password.desktop
rm -rf ~/files

#reboot
echo -e '\n ... Rebooting ... \n'
echo $PASSWORD | sudo -S reboot