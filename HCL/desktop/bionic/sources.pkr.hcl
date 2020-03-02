# Sources for bionic desktop image

source "hyperv-iso" "ubuntu_bionic" {
  iso_url      = "http://releases.ubuntu.com/${local.os_version}/ubuntu-${local.os_version}-${local.os_type}-amd64.iso"
  iso_checksum = local.iso_checksum
  ssh_password = var.ssh_password
  ssh_username = var.ssh_username
  switch_name  = "Default Switch"
  vm_name      = "${local.os_version}-${local.os_type}"

  communicator    = "ssh"
  cpus            = 1
  disk_block_size = 1
  disk_size       = 25600
  generation      = 2
  memory          = "4096"

  enable_dynamic_memory            = false
  enable_mac_spoofing              = true
  enable_virtualization_extensions = true

  output_directory = "..\\..\\vm\\packer\\${local.os_name}-{{timestamp}}"
  skip_export = true

  boot_wait        = "2s"
  http_directory   = "./"
  shutdown_command = "echo '${local.ssh_password}' | sudo -S shutdown -P now"
  ssh_timeout      = "2h"
 
  boot_command = <<EOF
<esc><esc><esc><esc>
linux /casper/vmlinuz
url=http://{{.HTTPIP}}:{{.HTTPPort}}/preseed.cfg
boot=casper ip=dhcp automatic-ubiquity noninteractive noprompt --- <enter>
initrd /casper/initrd <enter>
boot<enter>
EOF
}
