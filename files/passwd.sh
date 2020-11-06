#!/bin/bash

# --------------------------------------------------------------------------------
# Reset user's password
# --------------------------------------------------------------------------------
set -o errexit
set -o errtrace
set -o nounset

password_check () {
    hash_current=$(echo "${current_password}" | sudo -S cat /etc/shadow 2>/dev/null | grep "$username" | awk -F: '{print $2}')
    IFS='$'
    read -ra arr_hash_current <<< "${hash_current}"
    unset IFS

    #debug info
    #echo "arr_hash_current length:"
    #echo "${#arr_hash_current[@]}"
    #echo "arr_hash_current values:"
    #printf '%s\n' "${arr_hash_current[@]}"

    if [ "${#arr_hash_current[*]}" -gt 0 ]
    then
        hash_validate=$(echo "${current_password}" | openssl passwd -stdin -"${arr_hash_current[1]}" -salt "${arr_hash_current[2]}")
        IFS='$'
        read -ra arr_hash_validate <<< "${hash_validate}"
        unset IFS

        #debug info
        #echo "arr_hash_validate length:"
        #echo "${#arr_hash_validate[@]}"
        #echo "arr_hash_validate values:"
        #printf '%s\n' "${arr_hash_validate[@]}"

        if [ "${arr_hash_validate[3]}" == "${arr_hash_current[3]}" ]
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
    new_password=$(< /dev/urandom tr -dc '[:alnum:]' | head -c 10)

    echo -e "${current_password}\n$new_password\n$new_password" | passwd &> /dev/null

    message="New password for user $username is: \n$new_password\n"
    echo -e "${message}"
}

main () {
    username=$(whoami)

    read -rsp "Please enter current password for username $username: " current_password

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
