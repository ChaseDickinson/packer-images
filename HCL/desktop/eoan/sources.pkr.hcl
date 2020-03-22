# Source for desktop build

source "hyperv-iso" "eoan_desktop" {
  boot_command                     = local.boot_command
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
  iso_url                          = local.iso_url
  iso_checksum                     = local.iso_checksum
  memory                           = 4096
  output_directory                 = local.output_directory
  ssh_username                     = local.ssh_username
  ssh_password                     = local.ssh_password
  ssh_timeout                      = "2h"
  shutdown_command                 = "echo ${local.ssh_password} | sudo -S shutdown -P now"
  switch_name                      = "Default Switch"
  vm_name                          = local.vm_name
}
