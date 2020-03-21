
source "hyperv-iso" "bionic_desktop" {
  boot_command = [<<EOF
<esc><esc><esc><esc>
linux /casper/vmlinuz 
url=http://{{.HTTPIP}}:{{.HTTPPort}}/preseed.cfg 
boot=casper automatic-ubiquity noninteractive noprompt --- <enter>
initrd /casper/initrd <enter>
boot<enter>
EOF
  ]
  boot_wait                        = "2s"
  communicator                     = "ssh"
  cpus                             = 1
  disk_block_size                  = 1
  disk_size                        = 25600
  enable_dynamic_memory            = false
  enable_mac_spoofing              = true
  enable_virtualization_extensions = true
  generation                       = 2
  http_directory                   = "./"
  iso_url                          = "http://releases.ubuntu.com/18.04.3/ubuntu-18.04.3-desktop-amd64.iso"
  iso_checksum                     = "{{user `iso_checksum`}}"
  memory                           = 4096
  output_directory                 = "..\\..\\..\\VMs\\desktop\\bionic\\{{timestamp}}"
  ssh_username                     = "{{user `ssh_username`}}"
  ssh_password                     = "{{user `ssh_password`}}"
  ssh_timeout                      = "2h"
  shutdown_command                 = "echo 'ubuntu' | sudo -S shutdown -P now"
  switch_name                      = "Default Switch"
  vm_name                          = "packer-{{user `os_version`}}-{{user `os_type`}}-{{timestamp}}"
}
