locals {
  date_time    = formatdate("YYYY.MM.DD.hh.mm.ss", timestamp())
  files        = "../../files"
  iso_checksum = "96a8095001d447bbb9078925d72f7a77a3f62fbd78460093759af4394ce83d79"
  os_name      = "eoan"
  os_type      = "desktop"
  os_version   = "19.10"
  scripts      = "../../scripts"
  ssh_username = "ubuntu"
  ssh_password = "ubuntu"
}

locals {
  boot_command = [<<EOF
<esc><esc><esc><esc><esc><esc><esc><esc><esc><esc><esc><esc>
linux /casper/vmlinuz 
preseed/url=http://{{.HTTPIP}}:{{.HTTPPort}}/${local.os_name}/preseed.cfg 
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
