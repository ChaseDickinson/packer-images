# Packer Ubuntu Builds

## This repo is a work in progress

## TODO: 

- Validate the `adds` output location
- Initial launch of `zsh` & `VS Code` - Need to test in the next build success
- Split functions & aliases into dedicated files
- Vagrant boxes for servers
- Remote development configuration for VS Code to Vagrant boxes
- Figure out how to cut out the extra directory in the zip file export
- Create Chef cookbooks (or Ansible playbooks?)
- Convert focal server to new installer (or customize an existing Vagrant box?)
- Password retry logic (or only access via Vagrant?)
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
│   ├── config
│   │   ├── common.json - common variables across all builders
│   │   ├── bionic - config files for Bionic Beaver
│   │   │   ├── desktop.cfg - preseed file for desktop
│   │   │   ├── desktop.json - variables needed for desktop build
│   │   │   ├── server.cfg - preseed file for server
│   │   │   └── server.json - variables needed for server build
│   │   └── focal - config files for Focal Fossa
│   │       ├── desktop.cfg
│   │       ├── desktop.json
│   │       ├── server.cfg
│   │       └── server.json
│   ├── adds.json - template to utilize base build and install customizations
│   └── template.json - template to build a full customized image and a base image
├── Makefile - requires Make to be installed
├── README.md - you are here
├── cookbooks - future use
├── files
│   ├── code_extensions.list - list of VS Code extensions to be installed
│   ├── install.sh - install script to enable enhanced VM functionality in Hyper-V
│   ├── passwd.sh - script to change user's password at first login
│   └── settings.json - VS Code settings
└── scripts
    ├── base.sh - configure base image
    ├── desktop.sh - configure desktop image
    ├── linux_cloud_tools.sh - enable enhanced VM functionality in Hyper-V
    ├── server.sh - configure server image
    └── tools.sh - install desired tools
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
  - Chef Workstation
  - Docker & Docker-Compose
  - GIT
  - Microsoft's [linux-vm-tools](https://github.com/microsoft/linux-vm-tools) (enable "Enhanced Mode" for Ubuntu VMs)
  - Oh-My-Zsh
  - Packer
  - Python3
  - Terraform
  - Vagrant
  - Virtual Box
  - VS Code
    - Also installing some of my preferred VS Code extensions and configuration settings
