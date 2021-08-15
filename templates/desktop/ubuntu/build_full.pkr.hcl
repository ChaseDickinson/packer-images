########################################
# Builds
########################################
build {
  sources = [
    "source.virtualbox-iso.full"
  ]

  # Install the latest upgrades & reboot
  provisioner "shell" {
    execute_command = "echo '${local.ssh_password}' | sudo -S sh -ceux '{{ .Vars }} {{ .Path }}'"
    pause_before    = "10s"
    script          = "${local.scripts_dir}/upgrades.sh"
  }

  provisioner "shell" {
    expect_disconnect = true
    pause_before      = "10s"
    inline = [
      "echo '${local.ssh_password}' | sudo -S shutdown -r now"
    ]
  }

  # Configure environment as sudo
  provisioner "shell" {
    environment_vars = [
      "USERNAME=${local.ssh_username}"
    ]

    execute_command = "echo '${local.ssh_password}' | sudo -S sh -ceux '{{ .Vars }} {{ .Path }}'"
    pause_before    = "10s"
    scripts = [
      "${local.scripts_dir}/tools.sh",
      "${local.scripts_dir}/${var.os_type}.sh",
      "${local.scripts_dir}/sudoers.sh"
    ]
  }

  provisioner "shell" {
    expect_disconnect = true
    pause_before      = "10s"
    inline = [
      "echo '${local.ssh_password}' | sudo -S shutdown -r now"
    ]
  }

  # Configure environment as Vagrant user
  provisioner "shell" {
    pause_before = "10s"
    scripts = [
      "${local.scripts_dir}/user_base.sh",
      "${local.scripts_dir}/user_settings.sh"
    ]
  }

  # Finish up and stage for packaging of Vagrant box
  provisioner "shell" {
    execute_command = "echo '${local.ssh_password}' | sudo -S sh -ceux '{{ .Path }}'"
    pause_before    = "10s"
    scripts = [
      "${local.scripts_dir}/vagrant.sh",
      #"${local.scripts_dir}/cleanup.sh",
      #"${local.scripts_dir}/minimize.sh"
    ]
  }

  # Create Vagrant box
  post-processor "vagrant" {
    keep_input_artifact  = false
    output               = "${local.artifact_directory}/${source.type}_${source.name}_${local.timestamp}.box"
    vagrantfile_template = local.vagrantfile_template
  }
}