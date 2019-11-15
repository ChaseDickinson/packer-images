# Ubuntu Desktop Hyper-V VMs by Packer

## Problem Statement

1. Disposable, repeatable environments - Install whatever I want, figure it out, then start clean (or add to the build)
2. Good user experience - Things like copy & paste from host to guest needs to work; bonus points if the refresh rate is not janky
3. Create as close to the "minimal install" experience as possible - I won't be playing solitaire or shopping on Amazon so I don't need those packages installed

## Repo Structure

```
|-- Distro
    |-- preseed.cfg - preseed file for Ubuntu install
    |-- remove.list - list of packages to be removed
    |-- template.json - Packer template
|-- files
    |-- code_extensions.list - list of VS Code extensions to install
    |-- settings.json - JSON settings for VS Code
|-- scripts
    |-- base_install.sh - base install packages
    |-- linux_vm_tools.sh - Microsoft linux-vm-tools install; enables enhanced mode
    |-- remove.sh - script to remove packages from /Distro/remove.list
    |-- user_config.sh - user-sepecific settings like dock favorites & VS Code setup
```

## Usage

Hyper-V is required.

Don't forget to disable Secure Boot after you create a VM!

Once the build completes, copy the VHD to a different directory, then point a new Hyper-V VM to it during setup. You'll have to run the following command from an elevated PowerShell prompt for the "Enhanced Mode" functionality to work:

`Set-VM -VMName <your_vm_name> -EnhancedSessionTransportType HvSocket`

## Noob Logic

Well aware there's probably an easier/better way to accomplish this, but I was not able to find working examples when I looked so I'm sharing my functional imperfection.

- Why are you using the server images and installing the desktop GUI?
  - Because I can't get the damn desktop images to boot! I kept getting a kernel panic with a message about "VFS: Unable to mount root fs on unknown-block(0,0)". I spent hours on Google trying to figure this out, and as a general life rule, if I can't find an answer on Google after lookking for an extended period of time, it's probably a "me" problem.
  - Based on some research, the only difference between the Ubuntu images (besides obviously something with the installation/boot process) is the server doesn't preinstall a GUI while the desktop image does.

So I'm using the server images, then installing the packages I want.

- What are you installing? 
  - Ubuntu Desktop
  - VS Code
  - GIT
  - Python3
  - AWS CLI
  - AWS SAM, which requires:
    - Docker (and pre-reqs)
    - Homebrew (and pre-reqs)
  - Microsoft's [linux-vm-tools](https://github.com/microsoft/linux-vm-tools) (enable "Enhanced Mode" for Ubuntu VMs)
  - Also installing some of my preferred VS Code extensions

- What are you removing?
  - Pretty much everything that is listed as getting removed during the Ubuntu minimal installation
    - [bionic](https://people.canonical.com/~ubuntu-archive/seeds/ubuntu.bionic/desktop.minimal-remove)
    - [disco](https://people.canonical.com/~ubuntu-archive/seeds/ubuntu.disco/desktop.minimal-remove)
    - [eoan](https://people.canonical.com/~ubuntu-archive/seeds/ubuntu.eoan/desktop.minimal-remove)

- What are you reinstalling?
  - gnome-control-center (because something in the minimal installation removes the settings menu...? ~~Linux~~ ~~Ubuntu~~ Technology is weird)

- Why aren't you installing Docker, Homebrew, or AWS SAM on 19.10 Eoan?
  - Because there's no Docker Community Edition available yet, which causes the install to fail for that version

- Why are you updating the kernel?
  - Because the Microsoft linux-vm-tools package requires it; if I don't do it before running that install, it requires me to run the install twice so that it can do it for me

- This is unsecure because you're leaving "ubuntu" set as the default username and password!
  - Password is set to expire in a day
