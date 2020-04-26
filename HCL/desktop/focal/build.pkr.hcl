# Builds for focal desktop image

build {
  sources = ["source.hyperv-iso.focal_desktop"]

  provisioner "file" {
    destination = local.home
    source      = var.files
  }

  provisioner "shell" {
    expect_disconnect = true
    pause_after       = "10s"

    environment_vars = [
      "OS_NAME=${var.os_name}",
      "USERNAME=${var.ssh_username}",
      "PASSWORD=${var.ssh_password}"
    ]

    scripts = [
      "${var.scripts}/base.sh",
      "${var.scripts}/desktop.sh",
      "${var.scripts}/linux_vm_tools.sh"
    ]
  }
}
