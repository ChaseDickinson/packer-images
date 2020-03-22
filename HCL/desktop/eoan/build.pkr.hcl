# Builds for eoan desktop image

build {
  sources = ["source.hyperv-iso.eoan_desktop"]

  provisioner "file" {
    destination = local.home
    source      = local.files
  }

  provisioner "shell" {
    expect_disconnect = true
    pause_after       = "10s"

    environment_vars = [
      "OS_NAME=${local.os_name}",
      "USERNAME=${local.ssh_username}",
      "PASSWORD=${local.ssh_password}"
    ]

    scripts = [
      "${local.scripts}/base.sh",
      "${local.scripts}/desktop.sh",
      "${local.scripts}/linux_vm_tools.sh"
    ]
  }
}
