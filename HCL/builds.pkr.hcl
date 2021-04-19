########################################
# Builds
########################################
build {
  sources = [
    "source.hyperv-iso.base",
    "source.hyperv-iso.full",
  ]

  provisioner "shell" {
    environment_vars = [
      "PASSWORD=${local.ssh_password}",
      "USERNAME=${local.ssh_username}"
    ]

    expect_disconnect = true
    pause_before      = "10s"

    scripts = [
      "${local.scripts_dir}/base.sh",
      "${local.scripts_dir}/linux_cloud_tools.sh",
    ]
  }

  provisioner "file" {
    destination = local.home
    source      = local.files_dir
    only        = ["hyperv-iso.full"]
  }

  provisioner "shell" {
    environment_vars = [
      "PASSWORD=${local.ssh_password}",
      "USERNAME=${local.ssh_username}"
    ]

    expect_disconnect = true
    pause_before      = "10s"

    scripts = [
      "${local.scripts_dir}/tools.sh",
      "${local.scripts_dir}/${var.os_type}.sh"
    ]
    only = ["hyperv-iso.full"]
  }

  post-processor "shell-local" {
    environment_vars = [
      "SOURCE=${local.base_output_directory}",
      "DESTINATION=${local.export_directory}\\base\\${var.os_name}_${var.os_type}"
    ]

    inline = [
      "echo \"Removing Directory: %DESTINATION%\"",
      "rmdir /Q /S %DESTINATION%",
      "echo \"Sleeping for 5 Seconds\"",
      "sleep 5",
      "echo \"Copying %SOURCE% to %DESTINATION%\"",
      "xcopy %SOURCE% %DESTINATION% /E/H/I",
      "echo \"Removing Directory: %SOURCE%\"",
      "rmdir /Q /S %SOURCE%"
    ]

    tempfile_extension = ".cmd"
    only               = ["hyperv-iso.base"]
  }

  post-processor "compress" {
    keep_input_artifact = false
    output              = "${local.zip_directory}.full.zip"
    only                = ["hyperv-iso.full"]
  }
}