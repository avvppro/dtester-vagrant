
BOX_IMAGE = "centos/7"
APPLICATION_COUNT = 2
Vagrant.configure("2") do |config|
        config.vm.define "database" do |subconfig|
            subconfig.vm.provider "virtualbox" do |v|
                v.name = "db2_vm"
            end
            subconfig.vm.box = BOX_IMAGE
            subconfig.vm.network "private_network", ip: "192.168.33.11"
            subconfig.vm.provider "virtualbox" do |vb|
                vb.memory = "1024"
                vb.cpus = "1"
            end
            subconfig.vm.provision :shell, path: "db_vm.sh"
        end
        (1..APPLICATION_COUNT).each do |i|
            config.vm.define "application#{i}" do |subconfig|
                subconfig.vm.provider "virtualbox" do |v|
                    v.name = "app#{i}_vm"
                end
                 subconfig.vm.box = BOX_IMAGE
                subconfig.vm.network "private_network", ip: "192.168.33.#{50+i}"
                subconfig.vm.provider "virtualbox" do |vb|
                    vb.memory = "2048"
                    vb.cpus = "1"
                 end
                 subconfig.vm.provision :shell, path: "app_vm.sh"
             end
        end
        config.vm.define "be_balancer" do |subconfig|
            subconfig.vm.provider "virtualbox" do |v|
                v.name = "be_balancer_vm"
            end
            subconfig.vm.box = BOX_IMAGE
            subconfig.vm.network "private_network", ip: "192.168.33.150"
            subconfig.vm.provider "virtualbox" do |vb|
                vb.memory = "1024"
                vb.cpus = "1"
            end
            subconfig.vm.provision :shell, path: "be_balancer_vm.sh"
        end
end
