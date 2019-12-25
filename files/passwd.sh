#!/bin/bash

username=$(whoami)

read -sp "Please enter current password for username $username: " current_password

echo " "

password_change () {
    new_password=$(openssl rand -base64 12)

    echo -e "$current_password\n$new_password\n$new_password" | passwd &> /dev/null

    message="New password for user $username is: \n$new_password"
    echo -e $message
}

output=$(password_change)

echo -e "$output"
