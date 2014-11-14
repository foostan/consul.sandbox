# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

CONSUL_SERVER_NUM = 3
CONSUL_CLIENT_NUM = 1

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "yungsang/coreos-alpha"

  (1..CONSUL_SERVER_NUM).each do |i|
    node_name = "consul-server-#{i}"
    config.vm.define vm_name = node_name do |server|
      ip = "192.168.33.#{i+10}"
      server.vm.hostname = node_name
      server.vm.network :private_network, ip: ip
      server.vm.synced_folder ".", "/home/core/vagrant", id: "core", :nfs => true,  :mount_options => ['nolock,vers=3,udp']
      server.vm.provision "docker" do |d|
        if i == 1
          # bootstraping node
          d.run "progrium/consul",
            cmd: "-server -bootstrap-expect 1 -advertise #{ip}",
            args: "-h #{node_name} -p 8300:8300 -p 8301:8301/tcp -p 8301:8301/udp -p 8302:8302/tcp -p 8302:8302/udp -p 8400:8400 -p 8500:8500 -p 8600:53/udp"
        else
          d.run "progrium/consul",
            cmd: "-server -advertise #{ip} -join 192.168.33.11",
            args: "-h #{node_name} -p 8300:8300 -p 8301:8301/tcp -p 8301:8301/udp -p 8302:8302/tcp -p 8302:8302/udp -p 8400:8400 -p 8500:8500 -p 8600:53/udp"
        end
      end
    end
  end

  (1..CONSUL_CLIENT_NUM).each do |i|
    node_name = "consul-client-#{i}"
    config.vm.define vm_name = node_name do |server|
      ip = "192.168.33.#{i+20}"
      server.vm.hostname = node_name
      server.vm.network :private_network, ip: ip
      server.vm.synced_folder ".", "/home/core/vagrant", id: "core", :nfs => true,  :mount_options => ['nolock,vers=3,udp']
      server.vm.provision "docker" do |d|
        d.run "progrium/consul",
          cmd: "-advertise #{ip} -join 192.168.33.11",
          args: "-h #{node_name} -p 8300:8300 -p 8301:8301/tcp -p 8301:8301/udp -p 8302:8302/tcp -p 8302:8302/udp -p 8400:8400 -p 8500:8500 -p 8600:53/udp"
      end
    end
  end
end
