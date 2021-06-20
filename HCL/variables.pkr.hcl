########################################
# Local Variables
########################################
locals {
  # Output variables
  archive_filename = "${local.timestamp}.zip"
  export_directory = "C:\\vms\\${local.os_info}"
  os_info          = "${var.os_name}_${var.os_type}"
  output_directory = "..\\..\\vms\\${local.os_info}"
  timestamp        = formatdate("YYMMDDhhmm", timestamp())

  # Maps
  artifact_outputs = {
    "adds" = "${local.export_directory}\\adds\\${local.archive_filename}"
    "full" = "${local.export_directory}\\full\\${local.archive_filename}"
    "base" = "${local.export_directory}\\base"
  }

  vm_names = {
    "adds" = "${local.os_info}_adds"
    "base" = "${local.os_info}_base"
    "full" = "${local.os_info}_full"
  }

  # VM Specifications
  boot_wait        = "2s"
  communicator     = "ssh"
  cpus             = "2"
  disk_block_size  = "1"
  disk_size        = "25600"
  generation       = "2"
  headless         = "true"
  home             = "/home/${local.ssh_username}/"
  http_directory   = "${path.cwd}/HCL/config/${var.os_name}"
  iso_url          = "http://releases.ubuntu.com/${var.os_version}/ubuntu-${var.os_version}-${var.os_type}-amd64.iso"
  keep_registered  = "false"
  memory           = "3072"
  scripts_dir      = "scripts"
  shutdown_command = "echo '${local.ssh_password}' | sudo -S shutdown -P now"
  skip_export      = "true"
  ssh_password     = "ubuntu"
  ssh_timeout      = "2h"
  ssh_username     = "ubuntu"
  switch_name      = "Default Switch"
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