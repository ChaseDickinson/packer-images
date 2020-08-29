# Packer Ubuntu Builds

## This repo is a work in progress

## TODO: 

- Add Packer debug configuration
- Vagrant boxes for servers
- Remote development configuration for VS Code to Vagrant boxes
- Create Chef cookbooks
- Convert to HCL
- Convert focal server to new installer
- Password retry logic
- Validate/cleanup preseed files

## Problem Statement

I built this out mostly for my own use, and I'm sharing in case it's helpful to anyone else. Should be fairly straight-forward to edit to meet your own needs.

My primary goals are:

1. Disposable, repeatable environments - Spin up an environment with my tools of choice, experiment, then destroy it
2. Good user experience - Things like copy & paste from host to guest needs to work; bonus points if the refresh rate is not janky
3. Create as close to the "minimal install" experience as possible - I won't be playing solitaire or shopping on Amazon so I don't need those packages installed

## Repo Structure

```ascii
.
├── JSON
│   ├── bionic
│   │   ├── desktop.cfg - preseed for desktop image
│   │   ├── desktop.json - variables for desktop image
│   │   ├── server.cfg - preseed for server image
│   │   └── server.json - variables for server image
│   ├── focal
│   │   ├── desktop.cfg
│   │   ├── desktop.json
│   │   ├── server.cfg
│   │   └── server.json
│   ├── adds.json - template to add customizations to base image
│   ├── base.json - template for base image
│   └── full.json - template for full image
├── Makefile
├── README.md
├── cookbooks - future use
├── files
│   ├── .p10k.zsh - Powerlevel10k dotfile
│   ├── .zshrc - Zsh dotfile
│   ├── code_extensions.list - VS Code extensions to be installed
│   ├── install-bionic.sh - enable enhanced experience for Hyper-V
│   ├── install-focal.sh - enable enhanced experience for Hyper-V
│   ├── passwd.sh - prompt for password to be changed at first login
│   └── settings.json - VS Code settings
└── scripts
    ├── base.sh - configuration of base image
    ├── desktop.sh - configuration of desktop image
    ├── linux_cloud_tools.sh - enable enhanced experience for Hyper-V
    ├── server.sh - configuration of server image
    └── tools.sh - configuration of various tools
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

Alternatively, you can use the makefile by abbreviating the version and type of image desired. `fd` will build a Focal desktop image, and `bs` will build a Bionic server image. Requires Make to be installed to work correctly.

```powershell
make fd
```

```powershell
make bs
```

Hyper-V only for now.

VMs will output to whatever is defined as the `output_drive` variable.

Don't forget to disable Secure Boot after you create a VM!

Once the build completes, copy the VHD to a different directory, then point a new Hyper-V VM to it during setup. You'll have to run the following command from an elevated PowerShell prompt (replace <your_vm_name> with the name of the VM you created) for the "Enhanced Mode" functionality to work:

```powershell
Set-VM -VMName <your_vm_name> -EnhancedSessionTransportType HvSocket
```

If you want to be able to use virtualization within the guest OS, you will need to enable that as well:

```powershell
Set-VMProcessor -VMName <your_vm_name> -ExposeVirtualizationExtensions $true
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
