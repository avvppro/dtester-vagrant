
BOX_IMAGE = "centos/7"
Vagrant.configure("2") do |config|
        config.vm.define "database1" do |subconfig|
            subconfig.vm.provider "virtualbox" do |v|
                v.name = "db1_vm"
            end
            subconfig.vm.box = BOX_IMAGE
            subconfig.vm.network "private_network", ip: "192.168.33.100"
            subconfig.vm.provider "virtualbox" do |vb|
                vb.memory = "1024"
                vb.cpus = "1"
            end
            subconfig.vm.provision :shell, path: "db1_vm.sh"
        end
        config.vm.define "application1" do |subconfig|
            subconfig.vm.provider "virtualbox" do |v|
                v.name = "app1_vm"
            end
            subconfig.vm.box = BOX_IMAGE
            subconfig.vm.network "private_network", ip: "192.168.33.200"
            subconfig.vm.provider "virtualbox" do |vb|
                vb.memory = "1024"
                vb.cpus = "1"
            end
            subconfig.vm.provision :shell, path: "app1_vm.sh"
        end

end
