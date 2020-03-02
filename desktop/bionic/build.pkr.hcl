# folder/build.pkr.hcl

build {
  sources = [
    "source.amazon-ebs.example-1",
    "source.virtualbox-iso.example-2"
  ]

  provisioner "shell" {
    inline = [
      "echo it's alive !"
    ]
  }
}
