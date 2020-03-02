# folder/sources.pkr.hcl

source "amazon-ebs" "example-1" {
  ami_name = "example-1-ami"
}

source "virtualbox-iso" "example-2" {
  boot_command = <<EOF
<esc><esc><enter><wait>
/install/vmlinuz noapic 
...
EOF
}

source "hyperv-iso" "ubuntu_bionic" {
  boot_command = <<EOF

EOF
  boot_wait = "2s"
  communicator = "ssh"
  cpus = 1
  disk_block_size = 1
  disk_size = 25600
  enable_dynamic_memory = false
  enable_mac_spoofing = true
  enable_virtualization_extensions = true
  generation = 2
  http_directory = "./"
  iso_url = "http://releases.ubuntu.com/${local.os_version}/ubuntu-${local.os_version}-${local.os_type}-amd64.iso"
  iso_checksum = local.iso_checksum
  memory = "4096"
  output_directory = "..\\..\\vm\\packer\\${local.os_name}-{{timestamp}}"
  shutdown_command": "echo '${local.ssh_password}' | sudo -S shutdown -P now"
  skip_export = true
  ssh_password = var.ssh_password
  ssh_timeout = "2h"
  ssh_username = var.ssh_username
  switch_name = "Default Switch"
  vm_name = "${local.os_version}-${local.os_type}"
}
