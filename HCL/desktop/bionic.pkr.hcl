locals {
  boot_command = [<<EOF
<esc><esc><esc><esc><esc><esc><esc><esc><esc><esc><esc><esc>
linux /casper/vmlinuz 
url=http://{{.HTTPIP}}:{{.HTTPPort}}/preseed.cfg 
boot=casper automatic-ubiquity noninteractive noprompt --- <enter>
initrd /casper/initrd <enter>
boot<enter>
EOF
  ]
  date_time    = formatdate("YYYY.MM.DD.hh.mm.ss", timestamp())
  files        = "../../files"
  iso_checksum = "add4614b6fe3bb8e7dddcaab0ea97c476fbd4ffe288f2a4912cb06f1a47dcfa0"
  os_name      = "bionic"
  os_type      = "desktop"
  os_version   = "18.04.3"
  scripts      = "../../scripts"
  ssh_username = "ubuntu"
  ssh_password = "ubuntu"
}

locals {
  home             = "/home/${local.ssh_username}/"
  iso_url          = "http://releases.ubuntu.com/${local.os_version}/ubuntu-${local.os_version}-${local.os_type}-amd64.iso"
  output_directory = format("..\\..\\..\\vms\\%s\\%s\\%s", local.os_type, local.os_name, local.date_time)
}

source "hyperv-iso" "bionic_desktop" {
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
  vm_name                          = "${local.os_version}-${local.os_type}-packer"
}

build {
  sources = ["source.hyperv-iso.bionic_desktop"]

  provisioner "shell" {
    environment_vars = [

    ]
    expect_disconnect = true
    pause_after = 
    scripts = [
      "${local.scripts}/base.sh",
      "${local.scripts}/desktop.sh",
      "${local.scripts}/linux_vm_tools.sh"
    ]
  }
}
