########################################
# Local Variables
########################################
locals {
  base_output_directory = "${local.output_directory}\\${local.base_vm_name}"
  base_vm_name          = "${var.os_name}.${var.os_type}.base"
  boot_wait             = "2s"
  communicator          = "ssh"
  cpus                  = "1"
  disk_block_size       = "1"
  disk_size             = "25600"
  export_directory      = "C:\\vms"
  filename_prefix       = formatdate("YY.MM.DD", timestamp())
  files_dir             = "files"
  full_output_directory = "${local.output_directory}\\${local.full_vm_name}"
  full_vm_name          = "${local.vm_name}.full"
  generation            = "2"
  headless              = "true"
  home                  = "/home/${local.ssh_username}/"
  http_directory        = "${path.cwd}/HCL/config/${var.os_name}"
  iso_url               = "http://releases.ubuntu.com/${var.os_version}/ubuntu-${var.os_version}-${var.os_type}-amd64.iso"
  keep_registered       = "false"
  memory                = "2048"
  output_directory      = "..\\"
  scripts_dir           = "scripts"
  shutdown_command      = "echo '${local.ssh_password}' | sudo -S shutdown -P now"
  skip_export           = "true"
  ssh_password          = "ubuntu"
  ssh_timeout           = "2h"
  ssh_username          = "ubuntu"
  switch_name           = "Default Switch"
  timestamp             = formatdate("YYYYMMDDhhmmss", timestamp())
  vm_name               = "${local.timestamp}.${var.os_name}.${var.os_type}"
  zip_directory         = "${local.export_directory}\\${var.os_name}_${var.os_type}\\${local.filename_prefix}"
}

########################################
# Input Variables
########################################
variable "boot_command" {
  type = list(string)
}

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