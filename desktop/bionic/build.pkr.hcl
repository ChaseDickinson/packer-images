variables {
    files = "../../files"
    destination = "/home/{{user `username`}}/"
    password = "ubuntu"
    username = "ubuntu"
    os_nickname = "bionic"
    script_dir = "../../scripts"

    scripts = [
        "{{user `script_dir`}}/desktop_base.sh",
        "{{user `script_dir`}}/user_config.sh",
        "{{user `script_dir`}}/linux_vm_tools.sh"
    ]
}

build {
    sources = [
        "source.hyperv-iso.bionic_desktop",
    ]

    provisioner "file" {
        source = "{{user `files`}}"
        destination = "{{user `destination`}}"
    }

    provisioner "shell" {
        environment_vars = {
            OS_NICKNAME = "{{user `os_nickname`}}",
            USERNAME = "{{user `username`}}",
            PASSWORD = "{{user `password`}}"
        }
        expect_disconnect = true
        pause_before = "10s"
        scripts = "{{user `scripts`}}"
    }
}