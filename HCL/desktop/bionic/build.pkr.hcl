# Builds for bionic desktop image

build {
  sources = [
    "source.hyperv-iso.ubuntu_bionic"
  ]

  provisioner "file" {
    destination = local.home
    source      = var.files
  }

  provisioner "shell" {
    environment_vars = {
        "OS_NAME"  = local.os_name
        "USERNAME" = var.ssh_username
        "PASSWORD" = var.ssh_password
    }
    expect_disconnect = true
    pause_before = "10s"
    scripts = [
        "${var.scripts}/base.sh",
        "${var.scripts}/desktop.sh",
        "${var.scripts}/linux_vm_tools.sh",
    ]
  }
}
