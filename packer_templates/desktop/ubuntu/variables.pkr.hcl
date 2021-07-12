########################################
# Local Variables
########################################
locals {
  # Output variables
  artifact_directory = "../../output/${local.os_info}"
  os_info            = "${var.os_name}_${var.os_type}"
  build_directory    = "../builds/${local.os_info}"
  timestamp          = formatdate("YYMMDDhhmm", timestamp())

  # VM Specifications
  communicator     = "ssh"
  cpus             = "1"
  disk_size        = "25600"
  guest_os         = "Ubuntu_64"
  headless         = "true"
  http_directory   = "${path.root}http"
  iso              = "ubuntu-${var.os_version}-${var.os_type}-amd64.iso"
  iso_mirror       = "http://releases.ubuntu.com"
  iso_url          = "${local.iso_mirror}/${var.os_version}/${local.iso}"
  keep_registered  = "false"
  memory           = "2048"
  scripts_dir      = "${path.root}scripts"
  shutdown_command = "echo '${local.ssh_password}' | sudo -S shutdown -P now"
  ssh_password     = "vagrant"
  ssh_timeout      = "2h"
  ssh_username     = "vagrant"
}

########################################
# Input Variables
########################################
variable "iso_checksum" {
  type = string
}

variable "os_name" {
  type = string
}

variable "os_type" {
  type = string
}

variable "os_version" {
  type = string
}