Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"

  config.vm.synced_folder "./", "/home/vagrant/packer-images"

  config.vm.provider "virtualbox" do |v|
    v.name = "packer_dev"
    v.memory = 3072
    v.cpus = 2
  end
end