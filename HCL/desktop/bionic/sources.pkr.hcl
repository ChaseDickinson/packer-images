# --------------------------------------------------------------------------------
# Define locals
# --------------------------------------------------------------------------------

locals {
  date_time        = formatdate("YYYY.MM.DD.hh.mm.ss", timestamp())
  home             = "/home/${var.ssh_username}/"
  iso_url          = "http://releases.ubuntu.com/${var.os_version}/ubuntu-${var.os_version}-${var.os_type}-amd64.iso"
  keep_vm          = false
  output_directory = format("..\\..\\..\\vms\\%s", local.date_time)
  skip_export      = true
  vm_name          = "${var.os_version}-${var.os_type}-packer1.5"
}

locals {
  boot_command = <<EOF
<esc><esc><esc><esc><esc><esc><esc><esc><esc><esc><esc><esc>
linux /casper/vmlinuz 
url=http://{{.HTTPIP}}:{{.HTTPPort}}/${var.os_name}/preseed.cfg 
boot=casper automatic-ubiquity noninteractive noprompt --- <enter>
initrd /casper/initrd <enter>
boot<enter>
EOF
}

# --------------------------------------------------------------------------------
# Source for bionic desktop build
# --------------------------------------------------------------------------------

source "hyperv-iso" "bionic_desktop" {
  boot_command                     = [local.boot_command]
  boot_wait                        = "2s"
  communicator                     = "ssh"
  cpus                             = 1
  disk_block_size                  = 1
  disk_size                        = 25600
  generation                       = 2
  http_directory                   = "./"
  iso_url                          = local.iso_url
  iso_checksum                     = var.iso_checksum
  keep_registered                  = local.keep_vm
  memory                           = 4096
  output_directory                 = local.output_directory
  skip_export                      = local.skip_export
  ssh_username                     = var.ssh_username
  ssh_password                     = var.ssh_password
  ssh_timeout                      = "2h"
  shutdown_command                 = "echo ${var.ssh_password} | sudo -S shutdown -P now"
  switch_name                      = "Default Switch"
  vm_name                          = local.vm_name
}
