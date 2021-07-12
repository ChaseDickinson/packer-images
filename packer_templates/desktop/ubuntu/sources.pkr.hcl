########################################
# Virtualbox Sources
########################################
source "virtualbox-iso" "full" {
  communicator     = local.communicator
  cpus             = local.cpus
  disk_size        = local.disk_size
  guest_os_type    = local.guest_os
  headless         = local.headless
  http_directory   = local.http_directory
  iso_checksum     = var.iso_checksum
  iso_url          = local.iso_url
  keep_registered  = local.keep_registered
  memory           = local.memory
  output_directory = "${local.build_directory}/virtualbox-iso_${local.timestamp}"
  ssh_password     = local.ssh_password
  ssh_timeout      = local.ssh_timeout
  ssh_username     = local.ssh_username
  shutdown_command = local.shutdown_command
  vm_name          = "${local.os_info}_full"
  vboxmanage = [
    [
      "unattended",
      "install",
      "{{.Name}}",
      "--time-zone",
      "America/Chicago",
      "--iso",
      "${path.cwd}/packer_cache/b8e9b7e0fe39bb2818365ca98ec2fd090052dab0.iso",
      "--script-template",
      "${local.http_directory}/${var.os_type}.cfg",
    ]
  ]
}