########################################
# Base build
########################################
source "hyperv-iso" "base" {
  boot_command     = var.boot_command
  boot_wait        = local.boot_wait
  communicator     = local.communicator
  cpus             = local.cpus
  disk_block_size  = local.disk_block_size
  disk_size        = local.disk_size
  generation       = local.generation
  headless         = local.headless
  http_directory   = local.http_directory
  iso_checksum     = var.iso_checksum
  iso_url          = local.iso_url
  keep_registered  = local.keep_registered
  memory           = local.memory
  output_directory = local.base_output_directory
  shutdown_command = local.shutdown_command
  ssh_password     = local.ssh_password
  ssh_timeout      = local.ssh_timeout
  ssh_username     = local.ssh_username
  switch_name      = local.switch_name
  vm_name          = local.base_vm_name
}

########################################
# Full build
########################################
source "hyperv-iso" "full" {
  boot_command     = var.boot_command
  boot_wait        = local.boot_wait
  communicator     = local.communicator
  cpus             = local.cpus
  disk_block_size  = local.disk_block_size
  disk_size        = local.disk_size
  generation       = local.generation
  headless         = local.headless
  http_directory   = local.http_directory
  iso_checksum     = var.iso_checksum
  iso_url          = local.iso_url
  keep_registered  = local.keep_registered
  memory           = local.memory
  output_directory = local.full_output_directory
  shutdown_command = local.shutdown_command
  skip_export      = local.skip_export
  ssh_password     = local.ssh_password
  ssh_timeout      = local.ssh_timeout
  ssh_username     = local.ssh_username
  switch_name      = local.switch_name
  vm_name          = local.full_vm_name
}