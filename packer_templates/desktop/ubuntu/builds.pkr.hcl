########################################
# Builds
########################################
build {
  sources = [
    "source.virtualbox-iso.full"
  ]

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

  provisioner "file" {
    destination = "/tmp/files/"
    source      = "guest_files"
  }

  provisioner "shell" {
    pause_before = "10s"
    scripts = [
      "${local.scripts_dir}/user_base.sh",
      "${local.scripts_dir}/user_settings.sh"
    ]
  }

  provisioner "shell" {
    execute_command = "echo '${local.ssh_password}' | sudo -S sh -ceux '{{ .Path }}'"
    pause_before    = "10s"
    scripts = [
      "${local.scripts_dir}/vagrant.sh",
      "${local.scripts_dir}/cleanup.sh",
      "${local.scripts_dir}/minimize.sh"
    ]
  }

  post-processor "vagrant" {
    only = [
      "virtualbox-iso.full"
    ]

    keep_input_artifact = false
    output              = "${local.artifact_directory}\\${source.type}_${source.name}_${local.timestamp}.box"
  }
}