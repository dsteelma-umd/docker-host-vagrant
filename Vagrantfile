Vagrant.configure("2") do |config|
  config.vm.box = "geerlingguy/centos7"
  config.vm.network "private_network", ip: "192.168.7.25"
  
  config.vm.synced_folder "docker-host-env", "/apps/docker"

  config.vm.provision :shell, path: "./install.sh"
end
