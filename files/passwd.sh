#!/bin/bash

username=$(whoami)

read -sp "Please enter current password for username $username: " current_password

echo " "

password_check () {
    hash_current=$(echo $current_password | sudo -S cat /etc/shadow 2>/dev/null | grep ubuntu | awk -F: '{print $2}')
    IFS='$'; arr_hash_current=($hash_current); unset IFS;

    hash_validate=$(echo $current_password | openssl passwd -stdin -${arr_hash_current[1]} -salt ${arr_hash_current[2]})
    IFS='$'; arr_hash_validate=($hash_validate); unset IFS;

    if [ ${arr_hash_validate[3]} == ${arr_hash_current[3]} ]
    then
        result=0
    else
        result=1
    fi

    echo $result
}

password_change () {
    new_password=$(openssl rand -base64 12)

    echo -e "$current_password\n$new_password\n$new_password" | passwd &> /dev/null

    message="New password for user $username is: \n$new_password\n"
    echo -e $message
}

correct_password=$(password_check)

if [ $correct_password -eq 0 ]
then
    output=$(password_change)
    echo -e "$output"
    read -rsp $'Once you\'ve saved the new password, press ENTER to continue.\n'
    echo -n "yes" > ~/.config/password-reset-done
else
    echo "Incorrect password entered. Reboot to try again."
fi
