$dotfiles = <<SCRIPT
cd /home/vagrant
git clone git@github.com:ChaseDickinson/dotfiles.git
cd dotfiles
./install.sh
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.define "full" do |f|
    f.vm.box_url = "file:///C:/boxes/focal_desktop/virtualbox-iso_full_2108192018.box"
    f.vm.box = "focal_full"
    f.vm.synced_folder ".", "/vagrant", disabled: true
    f.vm.synced_folder ".", "/home/vagrant/wip/packer-images", mount_options: ["dmode=755", "fmode=664"]
    f.vm.provision "file", source: "../.gitconfig", destination: "/home/vagrant/.gitconfig"
    f.vm.provision "file", source: "../keys", destination: "/home/vagrant/.ssh"
    f.vm.provision "shell",
      inline: "chmod 700 /home/vagrant/.ssh && chmod 644 /home/vagrant/.ssh/known_hosts && chmod 644 /home/vagrant/.ssh/*.key.pub && chmod 600 /home/vagrant/.ssh/config && chmod 600 /home/vagrant/.ssh/*.key"
    f.vm.provision "shell", inline: $dotfiles, privileged: false
    f.vm.provider "virtualbox" do |vb|
      vb.name = "dev_vm_full"
      vb.customize ["modifyvm", :id, "--memory", 8192]
      vb.customize ["modifyvm", :id, "--cpus", 4]
      vb.customize ["modifyvm", :id, "--vram", "64"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--rtcuseutc", "on"]
      vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
      vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/MaxGuestResolution", "any"]
    end
    f.trigger.after :up, :reload do |trigger|
      trigger.info = "Setting VM display resolution"
      trigger.run = {inline: "vboxmanage controlvm \"dev_vm_full\" setvideomodehint 1600 1200 32"}
    end
  end

  config.vm.define "base" do |b|
    b.vm.box_url = "file:///C:/boxes/focal_desktop/virtualbox-iso_base_2108192018.box"
    b.vm.box = "focal_base"
    b.vm.synced_folder ".", "/vagrant", disabled: true
    b.vm.synced_folder ".", "/home/vagrant/wip/packer-images", mount_options: ["dmode=755", "fmode=664"]
    b.vm.provision "file", source: "../.gitconfig", destination: "/home/vagrant/.gitconfig"
    b.vm.provision "file", source: "../keys", destination: "/home/vagrant/.ssh"
    b.vm.provision "shell",
      inline: "chmod 700 /home/vagrant/.ssh && chmod 644 /home/vagrant/.ssh/known_hosts && chmod 644 /home/vagrant/.ssh/*.key.pub && chmod 600 /home/vagrant/.ssh/config && chmod 600 /home/vagrant/.ssh/*.key"
    b.vm.provider "virtualbox" do |vb|
      vb.name = "dev_vm_base"
      vb.customize ["modifyvm", :id, "--memory", 8192]
      vb.customize ["modifyvm", :id, "--cpus", 4]
      vb.customize ["modifyvm", :id, "--vram", "64"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--rtcuseutc", "on"]
      vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
      vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/MaxGuestResolution", "any"]
    end
    b.trigger.after :up, :reload do |trigger|
      trigger.info = "Setting VM display resolution"
      trigger.run = {inline: "vboxmanage controlvm \"dev_vm_base\" setvideomodehint 1600 1200 32"}
    end
  end
end