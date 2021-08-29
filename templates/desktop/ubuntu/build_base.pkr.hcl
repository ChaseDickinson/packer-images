########################################
# Builds
########################################
build {
  sources = [
    "source.virtualbox-iso.base"
  ]

  # Configure environment as Vagrant user
  provisioner "shell" {
    pause_before = "10s"
    script       = "${local.scripts_dir}/bootstrap.sh"
  }

  provisioner "ansible" {
    extra_arguments = [
      "--extra-vars",
      "ansible_become_pass=${local.ssh_password}",
      "-vvvv"
    ]

    playbook_file = "${local.playbooks_dir}/${source.name}.yml"
  }

  # Create Vagrant box
  post-processor "vagrant" {
    keep_input_artifact  = false
    output               = "${local.artifact_directory}/${source.type}_${source.name}_${local.timestamp}.box"
    vagrantfile_template = local.vagrantfile_template
  }
}