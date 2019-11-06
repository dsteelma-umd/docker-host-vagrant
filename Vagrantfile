Vagrant.configure("2") do |config|
  config.vm.box = "geerlingguy/centos7"
  config.vm.network "private_network", ip: "192.168.7.25"

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
  end
  
  # Giving shared folder global read/write access because we can't change the
  # owner/group of the directories (needed for logs and database volumes)
  config.vm.synced_folder "docker-host-env", "/apps/docker", type: "rsync",
                          rsync__exclude: ["volumes", "logs"]

  config.vm.provision "file", source: "docker-host-env/logs", destination: "/apps/docker/logs"
  config.vm.provision "file", source: "docker-host-env/volumes", destination: "/apps/docker/volumes"

  config.vm.provision :shell, path: "./install.sh"
end
