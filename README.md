# Packer Ubuntu Builds

## This repo is a work in progress

## TODO

1) Troublshoot Eoan Install
2) Add Virtualbox builder
3) Vagrant boxes for servers
4) Docker images for servers
5) Split desktop builds - base & additions
6) Password retry logic

## Problem Statement

I built this out mostly for my own use, and I'm sharing in case it's helpful to anyone else. Should be fairly straight-forward to edit to meet your own needs.

My primary goals are:

1. Disposable, repeatable environments - Spin up an environment with my tools of choice, experiment, then destroy it
2. Good user experience - Things like copy & paste from host to guest needs to work; bonus points if the refresh rate is not janky
3. Create as close to the "minimal install" experience as possible - I won't be playing solitaire or shopping on Amazon so I don't need those packages installed

## Repo Structure

```ascii
.
+-- [desktop]
|   +-- template.json - Packer template for OS type
|   +-- OS Version (bionic, eoan, etc.)
    |   +-- preseed.cfg - preseed file for specific OS version
    |   +-- variables.json - variable file for specific OS version
+-- files
|   +-- .zshrc - ZSH configuration
|   +-- code_extensions.list - list of VS Code extensions to install
|   +-- passwd.sh - Script to set random password at first login
|   +-- settings.json - JSON settings for VS Code
+-- HCL - Entire directory is still a WIP
+-- scripts
|   +-- base.sh - simple upgrade & cleanup
|   +-- desktop.sh - install packages and configuration settings for desktop images
|   +-- linux_vm_tools.sh - Microsoft linux-vm-tools install; enables enhanced mode
+-- .gitignore
+-- README.md
```

## Usage

There's one template per OS type (desktop or server). You'll need to invoke the Packer build command with the desired OS version:

PowerShell example for Bionic:

```powershell
packer build -var-file .\bionic\variables.json .\template.json
```

Linux example for Eoan:

```bash
packer build -var-file=./eoan/variables.json template.json
```

Hyper-V only for now.

VMs will output to a directory at the same level as the repository root, as a timestamped directory.

Don't forget to disable Secure Boot after you create a VM!

Once the build completes, copy the VHD to a different directory, then point a new Hyper-V VM to it during setup. You'll have to run the following command from an elevated PowerShell prompt (replace <your_vm_name> with the name of the VM you created) for the "Enhanced Mode" functionality to work:

```powershell
Set-VM -VMName <your_vm_name> -EnhancedSessionTransportType HvSocket
```

More on Microsoft's linux-vm-tools can be found on [their repo](https://github.com/microsoft/linux-vm-tools).

## What's Included

- What are you installing?
  - AWS CLI
  - Docker
  - GIT
  - Microsoft's [linux-vm-tools](https://github.com/microsoft/linux-vm-tools) (enable "Enhanced Mode" for Ubuntu VMs)
  - Node.js 12.x
  - Oh-My-Zsh
  - Python3
  - VS Code
    - Also installing some of my preferred VS Code extensions and configuration settings
