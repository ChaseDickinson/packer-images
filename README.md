# Packer Ubuntu Builds

## This repo is a work in progress

## TODO

1) Consolidate JSON builds into one set of templates; name variable files for OS type
2) Vagrant boxes for servers
3) Remote development configuration for VS Code to Vagrant boxes
4) Convert to HCL
5) Password retry logic
6) Validate/cleanup preseed files

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

You'll need to invoke the Packer build command with the desired OS version:

PowerShell example for Bionic:

```powershell
packer build -var-file .\bionic\variables.json .\full.json
```

Linux example for Focal:

```bash
packer build -var-file=./focal/variables.json full.json
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
  - Azure CLI
  - Chef Workstation
  - Docker & Docker-Compose
  - GIT
  - Microsoft's [linux-vm-tools](https://github.com/microsoft/linux-vm-tools) (enable "Enhanced Mode" for Ubuntu VMs)
  - Node.js 12.x
  - Oh-My-Zsh
  - Packer
  - Python3
  - Terraform
  - Vagrant
  - Virtual Box
  - VS Code
    - Also installing some of my preferred VS Code extensions and configuration settings
