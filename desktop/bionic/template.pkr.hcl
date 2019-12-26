#hyperv-iso builder

#challenges thus far:
#    - Validate commands still expect JSON
#    - {{user `variable`}} references do not behave as expected
#    - Splitting source & build file does not behave as expected

source "hyperv-iso" "bionic_desktop" {
    boot_command = [<<EOF
<esc><esc><esc><esc><esc><esc><esc><esc><esc><esc><esc><esc>
linux /casper/vmlinuz 
url=http://{{.HTTPIP}}:{{.HTTPPort}}/preseed.cfg 
boot=casper automatic-ubiquity noninteractive noprompt --- <enter>
initrd /casper/initrd <enter>
boot<enter>
EOF
]
    boot_wait = "2s"
    communicator = "ssh"
    cpus = 1
    disk_block_size = 1
    disk_size = 25600
    enable_dynamic_memory = false
    enable_mac_spoofing = true
    enable_virtualization_extensions = true
    generation = 2
    http_directory = "./"
    iso_url = "http://releases.ubuntu.com/18.04.3/ubuntu-18.04.3-desktop-amd64.iso"
    iso_checksum = "add4614b6fe3bb8e7dddcaab0ea97c476fbd4ffe288f2a4912cb06f1a47dcfa0"
    memory = 4096
    output_directory = "..\\..\\..\\VMs\\desktop\\bionic\\{{timestamp}}"
    ssh_username = "ubuntu"
    ssh_password = "ubuntu"
    ssh_timeout = "2h"
    shutdown_command = "echo 'ubuntu' | sudo -S shutdown -P now"
    switch_name = "Default Switch"
    vm_name = "18.04.3-desktop-packer"
}

build {
    sources = [
        "source.hyperv-iso.bionic_desktop"
    ]

    provisioner "file" {
        source = "../../files"
        destination = "/home/ubuntu/"
    }

    provisioner "shell" {
        environment_vars = [
            "OS_NAME=bionic",
            "USERNAME=ubuntu",
            "PASSWORD=ubuntu"
        ]
        expect_disconnect = true
        scripts = [
            "../../scripts/base.sh",
            "../../scripts/desktop.sh",
            "../../scripts/linux_vm_tools.sh"
        ]
    }
}