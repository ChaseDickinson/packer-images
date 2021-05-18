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
    only = [
      "hyperv-iso.base",
      "hyperv-iso.full"
    ]

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
    only = [
      "hyperv-iso.full",
      "hyperv-vmcx.adds"
    ]

    destination = local.home
    source      = local.files_dir
  }

  provisioner "shell" {
    only = [
      "hyperv-iso.full",
      "hyperv-vmcx.adds"
    ]

    expect_disconnect = true
    pause_before      = "10s"

    environment_vars = [
      "PASSWORD=${local.ssh_password}",
      "USERNAME=${local.ssh_username}"
    ]

    scripts = [
      "${local.scripts_dir}/tools.sh",
      "${local.scripts_dir}/${var.os_type}.sh"
    ]
  }

  post-processor "shell-local" {
    only = ["hyperv-iso.base"]

    tempfile_extension = ".cmd"

    environment_vars = [
      "SOURCE=${local.base_output_directory}",
      "DESTINATION=${local.base_artifact}"
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
      "hyperv-iso.full",
      "hyperv-vmcx.adds"
    ]

    keep_input_artifact = false
    output              = "${local.artifact_output}.${source.type}.zip"
  }
}