# TODO
# Figure out how to get around the lock error below!

########################################
# Builds
########################################
build {
  sources = [
    "source.hyperv-iso.full",
    "source.hyperv-iso.base",
    "source.hyperv-vmcx.adds",
  ]

  provisioner "shell" {
    execute_command = "echo '${local.ssh_password}' | sudo -S sh -c '{{ .Path }}'"
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
    execute_command = "echo '${local.ssh_password}' | sudo -S sh -c '{{ .Path }}'"
    pause_before    = "10s"
    scripts = [
      "${local.scripts_dir}/linux_cloud_tools.sh",
      "${local.scripts_dir}/cleanup.sh"
    ]
  }

  provisioner "shell" {
    pause_before = "10s"
    scripts = [
      "${local.scripts_dir}/user_base.sh"
    ]
  }

  provisioner "file" {
    only = [
      "hyperv-iso.full",
      "hyperv-vmcx.adds"
    ]

    destination = "/tmp/files/"
    source      = "guest_scripts"
  }

  provisioner "shell" {
    only = [
      "hyperv-iso.full",
      "hyperv-vmcx.adds"
    ]

    environment_vars = [
      "USERNAME=${local.ssh_username}"
    ]

    execute_command = "echo '${local.ssh_password}' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    pause_before    = "10s"
    scripts = [
      "${local.scripts_dir}/tools.sh",
      "${local.scripts_dir}/${var.os_type}.sh"
    ]
  }

  provisioner "shell" {
    expect_disconnect = true
    pause_before      = "10s"
    inline = [
      "echo '${local.ssh_password}' | sudo -S shutdown -r now"
    ]
  }

  provisioner "file" {
    only = [
      "hyperv-iso.full",
      "hyperv-vmcx.adds"
    ]

    destination = "/tmp/files/"
    source      = "guest_files"
  }

  provisioner "shell" {
    only = [
      "hyperv-iso.full",
      "hyperv-vmcx.adds"
    ]

    pause_before = "10s"
    scripts = [
      "${local.scripts_dir}/user_settings.sh"
    ]
  }

  post-processor "shell-local" {
    only = ["hyperv-iso.base"]

    tempfile_extension = ".cmd"

    environment_vars = [
      "SOURCE=base",
      "DESTINATION=${local.artifact_outputs.base}"
    ]

    inline = [
      "echo \"Removing Directory: %DESTINATION%\"",
      "rmdir /Q /S %DESTINATION%",
      "echo \"Sleeping for 5 Seconds\"",
      "timeout /t 5",
      "echo \"Copying %SOURCE% to %DESTINATION%\"",
      "xcopy %SOURCE% %DESTINATION% /E/H/I",
      "echo \"Removing Directory: %SOURCE%\"",
      "rmdir /Q /S %SOURCE%"
    ]
  }

  post-processor "compress" {
    only = [
      "hyperv-iso.full"
    ]

    keep_input_artifact = false
    output              = "${local.artifact_outputs.full}"
  }

  post-processor "compress" {
    only = [
      "hyperv-vmcx.adds"
    ]

    keep_input_artifact = false
    output              = "${local.artifact_outputs.adds}"
  }
}