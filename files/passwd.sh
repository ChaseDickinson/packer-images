#!/bin/bash

username=$(whoami)

read -sp "Please enter current password for username $username: " current_password

echo " "

password_check () {
    echo $current_password | sudo -S apt-get update &> /dev/null
    echo $?
}

password_change () {
    new_password=$(openssl rand -base64 10)

    echo -e "$current_password\n$new_password\n$new_password" | passwd &> /dev/null

    message="New password for user $username is: \n$new_password\n"
    echo -e $message
}

correct_password=$(password_check)

if [ $correct_password -eq 0 ]
then
    output=$(password_change)
    echo -e "$output"
    #this command closes the window before the new password can be captured [I'm guessing?]
    #echo -n "yes" > ~/.config/password-reset-done
else
    echo "Incorrect password entered. Reboot to try again."
fi
