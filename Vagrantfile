# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "dev_env"
  config.vm.box_url = "file:///C:/boxes/focal_desktop/virtualbox-iso_full_2107032047.box"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/home/vagrant/wip/packer-images"

  config.vm.provider "virtualbox" do |v|
    v.name = "dev_vm"
    v.memory = 8192
    v.cpus = 4
    v.gui = true
    v.customize ["modifyvm", :id, "--vram", "64", "--clipboard-mode", "hosttoguest", "--graphicscontroller", "vmsvga"]
  end
end