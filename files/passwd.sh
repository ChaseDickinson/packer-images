#!/bin/bash

password_check () {
    hash_current=$(echo $current_password | sudo -S cat /etc/shadow 2>/dev/null | grep "$username" | awk -F: '{print $2}')
    IFS='$'; arr_hash_current=($hash_current); unset IFS;

    if [ "${#arr_hash_current[*]}" -gt 0 ]
    then
        hash_validate=$(echo $current_password | openssl passwd -stdin -${arr_hash_current[1]} -salt ${arr_hash_current[2]})
        IFS='$'; arr_hash_validate=($hash_validate); unset IFS;

        if [ ${arr_hash_validate[3]} == ${arr_hash_current[3]} ]
        then
            validated=true
        else
            echo "Error: Hashes do not match."
            exit 1
        fi
    else
        echo "Error: Incorrect password entered for $username."
        exit 1
    fi
}

password_change () {
    new_password=$(cat /dev/urandom | tr -dc '[:alnum:]' | head -c 10)

    echo -e "$current_password\n$new_password\n$new_password" | passwd &> /dev/null

    message="New password for user $username is: \n$new_password\n"
    echo -e $message
}

main () {
    username=$(whoami)

    read -sp "Please enter current password for username $username: " current_password

    echo " "

    password_check

    if [ "$validated" ] && [ "${#arr_hash_current[*]}" -gt 0 ]
    then
        output=$(password_change)
        echo -e "$output"
        read -rsp $'Once you\'ve saved the new password, press ENTER to continue.\n'
        echo -n "yes" > ~/.config/password-reset-done
    else
        echo "Error: Unable to change password."
    fi
}

main
