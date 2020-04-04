#!/bin/bash

# ----------------------------------------
# Enable Enhanced VM functionality for Hyper-V
# ----------------------------------------
set -o errexit
set -o errtrace
set -o nounset

validateArguments() {
    if [ -z "${PASSWORD-}" ]; then
        printf "\n\nError: 'PASSWORD' is required.\n\n"
        exit 1
    fi
    if [ -z "${OS_NAME-}" ]; then
        printf "\n\nError: 'OS_NAME' is required.\n\n"
        exit 1
    fi
}

linuxVmTools() {
    if [ "${OS_NAME}" == "bionic"];
    then
        echo -e '\n****************************************\n'
        echo '  Installing prerequirements for Bionic'
        echo -e '\n****************************************\n'
        echo $PASSWORD | sudo -S apt-get install -y xserver-xorg-core xserver-xorg-input-all
    fi

    echo -e '\n****************************************\n'
    echo '  Installing Microsoft Linux-VM-Tools'
    echo -e '\n****************************************\n'
    wget https://raw.githubusercontent.com/Microsoft/linux-vm-tools/master/ubuntu/18.04/install.sh
    sed -i 's/apt/apt-get/g' install.sh
    chmod +x install.sh
    echo $PASSWORD | sudo -S ./install.sh
    rm install.sh
}

autoremove() {
    echo -e '\n****************************************\n'
    echo '  Autoremove'
    echo -e '\n****************************************\n'
    echo $PASSWORD | sudo -S apt-get update
    echo $PASSWORD | sudo -S apt-get autoremove -y
}

main() {
    validateArguments

    linuxVmTools

    autoremove
}

main
