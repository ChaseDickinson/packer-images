
build {
  sources = [
    "source.hyperv-iso.bionic_desktop"
  ]

  provisioner "file" {
    source      = "{{user `files`}}"
    destination = "{{user `home`}}"
  }

  provisioner "shell" {
    environment_vars = [
      "OS_NAME={{user `os_name`}}",
      "USERNAME={{user `ssh_username`}}",
      "PASSWORD={{user `ssh_password`}}"
    ]
    expect_disconnect = true
    scripts = [
      "{{user `scripts`}}/base.sh",
      "{{user `scripts`}}/desktop.sh",
      "{{user `scripts`}}/linux_vm_tools.sh"
    ]
  }
}
