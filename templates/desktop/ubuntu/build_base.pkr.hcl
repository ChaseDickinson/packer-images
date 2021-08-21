########################################
# Builds
########################################
build {
  sources = [
    "source.virtualbox-iso.base"
  ]

  # Install the latest upgrades and VirtualBox Guest Additions
  provisioner "shell" {
    environment_vars = [
      "USERNAME=${local.ssh_username}"
    ]

    execute_command   = "echo '${local.ssh_password}' | sudo -S sh -ceux '{{ .Vars }} {{ .Path }}'"
    expect_disconnect = true
    pause_before      = "10s"
    scripts = [
      "${local.scripts_dir}/1.upgrades.sh",
      "${local.scripts_dir}/reboot.sh",
      "${local.scripts_dir}/2.guest_additions.sh",
      "${local.scripts_dir}/reboot.sh"
    ]
  }

  # Configure environment as Vagrant user
  provisioner "shell" {
    environment_vars = [
      "USERNAME=${local.ssh_username}"
    ]

    pause_before = "10s"
    scripts = [
      "${local.scripts_dir}/5.ansible.sh",
      "${local.scripts_dir}/6.user_base.sh"
    ]

  }

  # Configure environment as sudo
  provisioner "shell" {
    environment_vars = [
      "USERNAME=${local.ssh_username}"
    ]

    execute_command   = "echo '${local.ssh_password}' | sudo -S sh -ceux '{{ .Vars }} {{ .Path }}'"
    expect_disconnect = true
    pause_before      = "10s"
    scripts = [
      "${local.scripts_dir}/reboot.sh",
      "${local.scripts_dir}/8.vagrant.sh",
      "${local.scripts_dir}/9.sudoers.sh",
      "${local.scripts_dir}/10.cleanup.sh",
      "${local.scripts_dir}/11.minimize.sh"
    ]
  }

  # Create Vagrant box
  post-processor "vagrant" {
    keep_input_artifact  = false
    output               = "${local.artifact_directory}/${source.type}_${source.name}_${local.timestamp}.box"
    vagrantfile_template = local.vagrantfile_template
  }
}