# Variables used in the source
variables {
    cpus = 1
    disk_size = "25600"
    iso_checksum = "add4614b6fe3bb8e7dddcaab0ea97c476fbd4ffe288f2a4912cb06f1a47dcfa0"
    iso_url = "http://releases.ubuntu.com/{{user `os_version`}}/ubuntu-{{user `os_version`}}-{{user `os_type`}}-amd64.iso"
    memory = "4096"
    output_directory = "..\\..\\..\\VMs\\{{user `os_type`}}\\{{user `os_nickname`}}\\{{timestamp}}"
    os_name = "ubuntu"
    os_nickname = "bionic"
    os_type = "desktop"
    os_version = "18.04.3"
    password = "ubuntu"
    switch_name = "Default Switch"
    username = "ubuntu"
    vm_name = "{{user `os_version`}}-{{user `os_type`}}-packer"
}

#hyperv-iso builder
source "hyperv-iso" "bionic_desktop" {
    iso_url = "{{user `iso_url`}}"
    iso_checksum = "{{user `iso_checksum`}}"
    communicator = "ssh"
    ssh_username = "{{user `username`}}"
    ssh_password = "{{user `password`}}"
    ssh_timeout = "2h"
    shutdown_command = "echo '{{user `password`}}' | sudo -S shutdown -P now"
    switch_name = "{{user `switch_name`}}"
    cpus = "{{user `cpus`}}"
    disk_block_size = "1"
    disk_size = "{{user `disk_size`}}"
    enable_dynamic_memory = false
    enable_mac_spoofing = true
    enable_virtualization_extensions = true
    generation = 2
    output_directory = "{{user `output_directory`}}"
    vm_name = "{{user `vm_name`}}"
    memory = "{{user `memory`}}"
    http_directory = "./"
    boot_wait = "0s"
    boot_command = <<EOF
<esc><esc><esc><esc><esc><esc><esc><esc><esc><esc><esc><esc>
linux /casper/vmlinuz 
url=http://{{.HTTPIP}}:{{.HTTPPort}}/preseed.cfg 
boot=casper automatic-ubiquity noninteractive noprompt --- <enter>
initrd /casper/initrd <enter>
boot<enter>
    EOF
}
