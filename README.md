# Packer Ubuntu Builds

## This repo is a work in progress

## TODO: 

- Analyze packages and services to see what can be removed to reduce artifact file size
- Generate Vagrant boxes
- Convert scripts to Ansible Playbooks
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
├── HCL
│   ├── builds.pkr.hcl
│   ├── config
│   │   ├── bionic
│   │   └── focal
│   │       ├── desktop.cfg
│   │       ├── desktop.pkrvars.hcl
│   │       ├── server.cfg
│   │       └── server.pkrvars.hcl
│   ├── sources.pkr.hcl
│   └── variables.pkr.hcl
├── Makefile
├── Makefile.ps1
├── README.md
├── Vagrantfile
├── guest_files
│   └── code_extensions.list
├── guest_scripts
│   ├── install.sh
│   └── passwd.sh
└── scripts
    ├── cleanup.sh
    ├── desktop.sh
    ├── linux_cloud_tools.sh
    ├── tools.sh
    ├── upgrades.sh
    ├── user_base.sh
    └── user_settings.sh
```

## Usage

You'll need to invoke the Packer build command with the desired OS version:

PowerShell example for full Focal build (execute from root of repo):

```powershell
packer build -only="hyperv-iso.full" -var-file ".\HCL\config\$nickname\desktop.pkrvars.hcl" .\HCL\
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
  - Terraform
  - Vagrant
  - Virtualbox
  - VS Code
    - Also installing some of my preferred VS Code extensions and configuration settings
