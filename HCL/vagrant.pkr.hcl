source "vagrant" "example" {
  communicator = "ssh"
  source_path = "bento/ubuntu-20.04"
  provider = "virtualbox"
  add_force = true
  insert_key = true
  teardown_method = destroy
}

build {
  sources = ["source.vagrant.example"]
}