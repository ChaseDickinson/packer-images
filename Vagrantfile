Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.network "public_network", bridge: "Default Switch"

  config.vm.provider "hyperv" do |h|
    h.vmname = "packer_dev"
    h.memory = 4096
    h.cpus = 2
    h.enable_virtualization_extensions = true
  end
end
# TODO
# To be able to install Virtualbox:
#   - Upgrade available packages
#   - Install libarchive-tools
#   - Install Virtualbox by following instructions here: https://www.virtualbox.org/wiki/Linux_Downloads