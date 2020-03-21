{
    "variables": {
        "files": "../files",
        "home": "/home/{{user `ssh_username`}}/",
        "os_type": "desktop",
        "output_drive": "{{env `ONEDRIVE`}}",
        "scripts": "../scripts",
        "ssh_username": "ubuntu",
        "ssh_password": "ubuntu"
    },
    "builders": [
        {
            "type": "hyperv-iso",
            "boot_command": [
                "<esc><esc><esc><esc>",
                "linux /casper/vmlinuz ",
                "url=http://{{.HTTPIP}}:{{.HTTPPort}}/{{user `os_name`}}/preseed.cfg ",
                "boot=casper ip=dhcp automatic-ubiquity noninteractive noprompt --- <enter>",
                "initrd /casper/initrd <enter>",
                "boot<enter>"
            ],
            "boot_wait": "2s",
            "communicator": "ssh",
            "cpus": "1",
            "disk_block_size": "1",
            "disk_size": "25600",
            "enable_dynamic_memory": false,
            "enable_mac_spoofing": true,
            "enable_virtualization_extensions": true,
            "generation": "2",
            "http_directory": "./",
            "iso_url": "http://releases.ubuntu.com/{{user `os_version`}}/ubuntu-{{user `os_version`}}-{{user `os_type`}}-amd64.iso",
            "iso_checksum": "{{user `iso_checksum`}}",
            "memory": "4096",
            "output_directory": "..\\..\\vm\\packer\\{{user `os_name`}}-{{timestamp}}",
            "shutdown_command": "echo '{{user `ssh_password`}}' | sudo -S shutdown -P now",
            "skip_export": true,
            "ssh_password": "{{user `ssh_password`}}",
            "ssh_timeout": "2h",
            "ssh_username": "{{user `ssh_username`}}",
            "switch_name": "Default Switch",
            "vm_name": "{{user `os_version`}}-{{user `os_type`}}"
        }
    ],
    "provisioners": [
        {
            "type": "file",
            "destination": "{{user `home`}}",
            "only": [
                "hyperv-iso"
            ],
            "source": "{{user `files`}}"
        },
        {
            "type": "shell",
            "environment_vars": [
                "OS_NAME={{user `os_name`}}",
                "USERNAME={{user `ssh_username`}}",
                "PASSWORD={{user `ssh_password`}}"
            ],
            "expect_disconnect": true,
            "only": [
                "hyperv-iso"
            ],
            "pause_before": "10s",
            "scripts": [
                "{{user `scripts`}}/base.sh",
                "{{user `scripts`}}/desktop.sh",
                "{{user `scripts`}}/linux_vm_tools.sh"
            ]
        }
    ],
    "post-processors": [
        {
            "type": "compress",
            "compression_level": 9,
            "format": ".zip",
            "keep_input_artifact": true,
            "only": [
                "hyperv-iso"
            ],
            "output": "{{user `output_drive`}}\\vm\\packer\\{{user `os_name`}}-{{timestamp}}.zip"
        }
    ]
}