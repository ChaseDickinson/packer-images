# Custom Ubuntu Hyper-V VMs by Packer

## Problem Statement

1. Disposable, repeatable environments - Install whatever I want, figure it out, then start clean (or add to the build)
2. Good user experience - Things like copy & paste from host to guest needs to work; bonus points if the refresh rate is not janky
3. Create as close to the "minimal install" experience as possible - I won't be playing solitaire or shopping on Amazon so I don't need those packages installed

## Noob Logic

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
  - Microsoft's linux-vm-tools (enable "Enhanced Mode" for Ubuntu VMs)
  - Also installing some of my preferred VS Code extensions

- What are you removing?
  - Everything that is listed as getting removed during the Ubuntu minimal installation (insert link)

- What are you reinstalling?
  - gnome-control-center (because something in the minimal installation removes the settings menu...? Linux is weird)

- Why aren't you installing Docker, Homebrew, or AWS SAM on 19.10 Eoan?
  - Because there's no Docker Community Edition available yet, which causes the install to fail for that version

- Why are you updating the kernel?
  - Because the Microsoft linux-vm-tools package requires it; if I don't do it before running that install, it requires me to run the install twice, while doing it for me

- This is unsecure because you're leaving "ubuntu" set as the default username and password!
  - Password is set to expire in a day

## Usage

Hyper-V is a requirement at this point.

Once the build completes, copy the VHD to a different directory, then point a new Hyper-V VM to it during setup. You'll have to run the following command from an elevated PowerShell prompt for the "Enhanced Mode" functionality to work:

`Set-VM -VMName <your_vm_name> -EnhancedSessionTransportType HvSocket`
