#!/bin/bash

# --------------------------------------------------------------------------------
# Reset user's password
# --------------------------------------------------------------------------------
set -o errexit
set -o errtrace
set -o nounset

password_check () {
    current_shadow=$(echo "${current_password}" | sudo -S cat /etc/shadow 2>/dev/null | grep -Po '(?<='"${username}"':)(.*?)(?=:)')

    if [[ -z "${current_shadow}" ]]
    then
      echo "Error: Incorrect password entered for ${username}."
      exit 1
    else
      current_algorithm=$(echo "${current_password}" | sudo -S cat /etc/shadow | grep -Po '(?<='"${username}"':\$)(\d)')
      current_salt=$(echo "${current_password}" | sudo -S cat /etc/shadow | grep -Po '(?<='"${username}"':\$\d\$)(.+?)(?=\$)')
      validate_shadow=$(echo "${current_password}" | openssl passwd -stdin -"${current_algorithm}" -salt "${current_salt}")

      if [[ "${validate_shadow}" == "${current_shadow}" ]]
      then
          validated=true
      else
          echo "Error: Hashes do not match."
          exit 1
      fi
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

    read -rsp "Please enter current password for username ${username}: " current_password

    echo " "

    password_check

    if [ "${validated}" ] && [ "${#validate_shadow}" -gt 0 ]
    then
        output=$(password_change)
        echo -e "${output}"
        read -rsp $'Once you\'ve saved the new password, press ENTER to continue.\n'
        echo -n "yes" > ~/.config/password-reset-done
    else
        echo "Error: Unable to change password."
    fi
}

main
