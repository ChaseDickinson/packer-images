locals {
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
  boot_command = [<<EOF
<esc><esc><esc><esc><esc><esc><esc><esc><esc><esc><esc><esc>
linux /casper/vmlinuz 
url=http://{{.HTTPIP}}:{{.HTTPPort}}/${local.os_name}/preseed.cfg 
boot=casper debug-ubiquity noninteractive noprompt --- <enter>
initrd /casper/initrd <enter>
boot<enter>
EOF
  ]

  home             = "/home/${local.ssh_username}/"
  iso_url          = "http://releases.ubuntu.com/${local.os_version}/ubuntu-${local.os_version}-${local.os_type}-amd64.iso"
  output_directory = format("..\\..\\..\\vms\\%s", local.date_time)
  vm_name          = "${local.os_version}-${local.os_type}-packer"
}
