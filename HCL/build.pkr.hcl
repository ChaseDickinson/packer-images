build {
  sources = ["source.hyperv-iso.base", "source.hyperv-iso.full"]

  provisioner "shell" {
    environment_vars  = ["PASSWORD=${var.ssh_password}", "USERNAME=${var.ssh_username}"]
    expect_disconnect = true
    pause_before      = "10s"
    scripts           = ["${var.scripts_dir}/base.sh", "${var.scripts_dir}/linux_cloud_tools.sh"]
  }

  provisioner "file" {
    destination = "${var.home}"
    only        = ["full"]
    source      = "${var.files_dir}"
  }

  provisioner "shell" {
    environment_vars  = ["PASSWORD=${var.ssh_password}", "USERNAME=${var.ssh_username}"]
    expect_disconnect = true
    only              = ["full"]
    pause_before      = "10s"
    scripts           = ["${var.scripts_dir}/tools.sh", "${var.scripts_dir}/${var.os_type}.sh"]
  }

  post-processor "shell-local" {
    environment_vars   = ["SOURCE=${var.base_output_directory}", "DESTINATION=${var.export_directory}\\base\\${var.os_name}_${var.os_type}"]
    inline             = ["echo \"Removing Directory: %DESTINATION%\"", "rmdir /Q /S %DESTINATION%", "echo \"Sleeping for 5 Seconds\"", "sleep 5", "echo \"Copying %SOURCE% to %DESTINATION%\"", "xcopy %SOURCE% %DESTINATION% /E/H/I", "echo \"Removing Directory: %SOURCE%\"", "rmdir /Q /S %SOURCE%"]
    only               = ["base"]
    tempfile_extension = ".cmd"
  }
  post-processor "compress" {
    keep_input_artifact = false
    only                = ["full"]
    output              = "${var.zip_directory}.full.zip"
  }
}
