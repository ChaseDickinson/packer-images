## This repo is a work in progress

## TODO

1) Add Virtualbox builder
2) Terminal theming - font & Powerline install
3) Adopt HCL2

## Problem Statement

I built this out mostly for my own use, and I'm sharing in case it's helpful to anyone else. Should be fairly straight-forward to edit to meet your own needs.

My primary goals are:

1. Disposable, repeatable environments - Spin up an environment with my tools of choice, experiment, then destroy it
2. Good user experience - Things like copy & paste from host to guest needs to work; bonus points if the refresh rate is not janky
3. Create as close to the "minimal install" experience as possible - I won't be playing solitaire or shopping on Amazon so I don't need those packages installed

## Repo Structure

```
|-- [desktop|server]
    |-- preseed.cfg - preseed file for Ubuntu install
    |-- template.json - Packer template
|-- files
    |-- code_extensions.list - list of VS Code extensions to install
    |-- settings.json - JSON settings for VS Code
|-- scripts
    |-- desktop_base.sh - base install packages for desktop images
    |-- linux_vm_tools.sh - Microsoft linux-vm-tools install; enables enhanced mode
    |-- server_base.sh - base install packages for server images
    |-- user_config.sh - user-sepecific settings like dock favorites & VS Code setup
```

## Usage

Hyper-V only for now.

VMs will output to a directory at the same level as the repository root, organized by image type (desktop or server) then OS version (bionic, disco, or eoan).

Don't forget to disable Secure Boot after you create a VM! You'll also need to login and change your password first before completing the step below to enable "Enhanced Mode".

Once the build completes, copy the VHD to a different directory, then point a new Hyper-V VM to it during setup. You'll have to run the following command from an elevated PowerShell prompt (replace <your_vm_name> with the name of the VM you created) for the "Enhanced Mode" functionality to work:

`Set-VM -VMName <your_vm_name> -EnhancedSessionTransportType HvSocket`

## What's Included

- What are you installing? 
  - VS Code
  - GIT
  - Python3
  - Node.js 12.x
  - AWS CLI
  - AWS SAM (on Bionic & Disco), which requires:
    - Docker (and pre-reqs)
    - Homebrew (and pre-reqs)
  - Microsoft's [linux-vm-tools](https://github.com/microsoft/linux-vm-tools) (enable "Enhanced Mode" for Ubuntu VMs)
  - Also installing some of my preferred VS Code extensions and configuration settings

## What's Not Included

- Taking advantage of the built in minimal install functionality included in the Ubuntu Desktop images. This removes the following packages:
    - [bionic](https://people.canonical.com/~ubuntu-archive/seeds/ubuntu.bionic/desktop.minimal-remove)
    - [disco](https://people.canonical.com/~ubuntu-archive/seeds/ubuntu.disco/desktop.minimal-remove)
    - [eoan](https://people.canonical.com/~ubuntu-archive/seeds/ubuntu.eoan/desktop.minimal-remove)

- Why aren't you installing Docker, Homebrew, or AWS SAM on 19.10 Eoan?
  - Because there's [no Docker Community Edition available yet for Eoan](https://docs.docker.com/install/linux/docker-ce/ubuntu/), which causes the install to fail for that version when it tries to find it

- Why are you updating the kernel?
  - Because the Microsoft linux-vm-tools package requires it; if I don't do it before running that install, it requires me to run the install twice so that it can do the upgrade for me

- This is not secure because you're leaving "ubuntu" set as the default username and password!
  - Password is set to expire and will require you to change it at next login
