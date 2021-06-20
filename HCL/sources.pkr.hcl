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
  output_directory = local.vm_names.full
  shutdown_command = local.shutdown_command
  skip_export      = local.skip_export
  ssh_password     = local.ssh_password
  ssh_timeout      = local.ssh_timeout
  ssh_username     = local.ssh_username
  switch_name      = local.switch_name
  vm_name          = local.vm_names.full
}

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
  output_directory = local.vm_names.base
  shutdown_command = local.shutdown_command
  ssh_password     = local.ssh_password
  ssh_timeout      = local.ssh_timeout
  ssh_username     = local.ssh_username
  switch_name      = local.switch_name
  vm_name          = local.vm_names.base
}

########################################
# Adds build
########################################
source "hyperv-vmcx" "adds" {
  clone_from_vmcx_path = local.artifact_outputs.base
  communicator         = local.communicator
  cpus                 = local.cpus
  disk_block_size      = local.disk_block_size
  generation           = local.generation
  headless             = local.headless
  keep_registered      = local.keep_registered
  memory               = local.memory
  output_directory     = local.vm_names.adds
  shutdown_command     = local.shutdown_command
  skip_export          = local.skip_export
  ssh_password         = local.ssh_password
  ssh_timeout          = local.ssh_timeout
  ssh_username         = local.ssh_username
  switch_name          = local.switch_name
  vm_name              = local.vm_names.adds
}
