Vagrant.configure("2") do |config|
  config.vm.box_url = "file:///C:/boxes/focal_desktop/virtualbox-iso_full_2107171842.box"

  config.vm.define "packer_dev" do |pd|
    pd.vm.box = "packer_dev"
    pd.vm.synced_folder ".", "/vagrant", disabled: true
    pd.vm.synced_folder ".", "/home/vagrant/wip/packer-images"
    pd.vm.synced_folder "C:/boxes", "/home/vagrant/output"
    pd.vm.provision "file", source: "../.gitconfig", destination: "/home/vagrant/.gitconfig"
    pd.vm.provision "file", source: "../keys", destination: "/home/vagrant/.ssh"
    pd.vm.provision "shell",
      inline: "chmod 644 /home/vagrant/.ssh/*.key.pub && chmod 600 /home/vagrant/.ssh/*.key"
    pd.vm.provision "shell",
      inline: "sudo ln -sv /usr/lib/virtualbox/UnattendedTemplates /usr/share/virtualbox/UnattendedTemplates"
    pd.vm.provider "virtualbox" do |vb|
      vb.name = "dev_vm"
      vb.memory = 8192
      vb.cpus = 4
      vb.gui = true
      vb.customize ["modifyvm", :id, "--vram", "64", "--clipboard-mode", "hosttoguest", "--graphicscontroller", "vmsvga", "--nested-hw-virt", "on"]
    end
  end
end