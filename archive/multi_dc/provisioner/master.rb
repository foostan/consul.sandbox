def provision_master(config, hostname, ip, server_num, client_num)
  (1..server_num).each do |si|
    first = si == 1 ? true : false
    cname = "server#{si}"

    if first
      # bootstrap consul
      config.vm.provision :docker, preserve_order: true do |d|
        d.run cname, image: "progrium/consul",
          cmd: "-server -dc #{hostname} -bootstrap-expect #{server_num}",
          args: "-h #{cname}"
      end

      # register a first server to a etcd
      config.vm.provision :shell, preserve_order: true do |sh|
        sh.inline = <<-EOT
          etcdctl set /consul/master/server `docker inspect -f '{{ .NetworkSettings.IPAddress }}' server1`
        EOT
      end
    else
      # join lan cluster
      config.vm.provision :docker, preserve_order: true do |d|
        d.run cname, image: "progrium/consul",
          cmd: "-server -dc #{hostname} -join `docker inspect -f '{{ .NetworkSettings.IPAddress }}' server1`",
          args: "-h #{cname}"
      end

      # join wan cluster
      config.vm.provision :shell, preserve_order: true do |sh|
        sh.inline = <<-EOT
          docker exec -it #{cname} consul join -wan `etcdctl get /consul/master/server`
        EOT
      end
    end
  end

  (1..client_num).each do |ci|
    cname = "client#{ci}"

    config.vm.provision :docker, preserve_order: true do |d|
      # join lan cluster
      d.run cname, image: "progrium/consul",
        cmd: "-dc #{hostname} -join `docker inspect -f '{{ .NetworkSettings.IPAddress }}' server1`",
        args: "-h #{cname}"
    end
  end
end
