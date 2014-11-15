# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

CONSUL_SERVER_NUM = 3
CONSUL_CLIENT_NUM = 1

IP_BASE = "192.168.33."

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "yungsang/coreos-alpha"

  (1..CONSUL_SERVER_NUM).each do |i|
    node_name = "consul-server-#{i}"
    config.vm.define vm_name = node_name do |server|
      ip = "#{IP_BASE}#{i+10}"
      if i == 1
        setup(server, node_name, ip, true, true)
      else
        setup(server, node_name, ip, true, false)
      end
    end
  end

  (1..CONSUL_CLIENT_NUM).each do |i|
    node_name = "consul-client-#{i}"
    config.vm.define vm_name = node_name do |client|
      ip = "#{IP_BASE}#{i+20}"
      setup(client, node_name, ip, false, false)
    end
  end
end

def setup(config, hostname, ip, server, bootstrap)
  config.vm.hostname = hostname
  config.vm.network :private_network, ip: ip
  config.vm.synced_folder ".", "/home/core/vagrant", id: "core", :nfs => true,  :mount_options => ['nolock,vers=3,udp']

  consul_opt_server = server ? '-server' : ''
  consul_opt_bootstrap = bootstrap ? '-bootstrap-expect 1' : ''

  config.vm.provision "docker" do |d|
    d.run "progrium/consul",
      cmd: "#{consul_opt_server} #{consul_opt_bootstrap} -advertise #{ip} -join #{IP_BASE}11",
      args: "-h consul-#{hostname} -p 8300:8300 -p 8301:8301/tcp -p 8301:8301/udp -p 8302:8302/tcp -p 8302:8302/udp -p 8400:8400 -p 8500:8500 -p 8600:53/udp"

    d.run "progrium/registrator",
      cmd: "consul://#{ip}:8500",
      args: "-h registrator-#{hostname} -v /var/run/docker.sock:/tmp/docker.sock"

    d.run "foostan/tinyweb",
      args: "-h blue-tinyweb-#{hostname} -p 80 -e 'SERVICE_TAGS=blue'"

    d.run "foostan/tinyweb",
      args: "-h green-tinyweb-#{hostname} -p 80 -e 'SERVICE_TAGS=green'"
  end
end
