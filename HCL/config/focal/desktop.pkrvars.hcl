boot_command = [
  "<esc><esc><esc><esc>linux /casper/vmlinuz ",
  "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/desktop.cfg ",
  "boot=casper automatic-ubiquity noninteractive noprompt --- <enter>",
  "initrd /casper/initrd <enter>",
  "boot<enter>"
]
iso_checksum = "93bdab204067321ff131f560879db46bee3b994bf24836bb78538640f689e58f"
os_name = "focal"
os_type = "desktop"
os_version = "20.04.2.0"