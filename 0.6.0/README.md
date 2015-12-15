# Consul-playground for 0.6.0

## setup
```shell
$ docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM
default   *        virtualbox   Running   tcp://192.168.99.101:2376
$ docker pull gliderlabs/consul:0.6
$ docker pull gliderlabs/consul-agent:0.6
$ docker pull gliderlabs/consul-server:0.6
$ docker images | grep gliderlabs/consul
gliderlabs/consul-server   0.6                 703db881609c        About a minute ago   39.3 MB
gliderlabs/consul-agent    0.6                 af30ce5496d7        8 minutes ago        38.05 MB
gliderlabs/consul          0.6                 a50000644982        8 minutes ago        38.05 MB
```
Build gliderlabs/consul(https://github.com/gliderlabs/docker-consul) yourself if missing gliderlabs/consul:0.6.

## start and clustering
```
$ docker run -d -p 8500:8500 --name node1 -h node1 gliderlabs/consul-server:0.6 -server -bootstrap-expect 3
$ JOIN_IP="$(docker inspect -f '{{.NetworkSettings.IPAddress}}' node1)"
$ docker run -d --name node2 -h node2 gliderlabs/consul-server:0.6 -server -join $JOIN_IP
$ docker run -d --name node3 -h node3 gliderlabs/consul-server:0.6 -server -join $JOIN_IP
$ docker run -d --name node4 -h node4 gliderlabs/consul-agent:0.6 -join $JOIN_IP
$ docker run -d --name node5 -h node5 gliderlabs/consul-agent:0.6 -join $JOIN_IP
$ docker run -d --name node6 -h node6 gliderlabs/consul-agent:0.6 -join $JOIN_IP
$ docker run -d --name node7 -h node7 gliderlabs/consul-agent:0.6 -join $JOIN_IP
$ docker run -d --name node8 -h node8 gliderlabs/consul-agent:0.6 -join $JOIN_IP
$ docker run -d --name node9 -h node9 gliderlabs/consul-agent:0.6 -join $JOIN_IP
$ docker ps
CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS              PORTS                                                                                NAMES
4e5c01482fa7        gliderlabs/consul-agent:0.6    "/bin/consul agent -c"   10 seconds ago      Up 3 seconds        8300-8302/tcp, 8400/tcp, 8500/tcp, 8301-8302/udp, 8600/tcp, 8600/udp                 node9
c4e2b1b12a27        gliderlabs/consul-agent:0.6    "/bin/consul agent -c"   13 seconds ago      Up 6 seconds        8300-8302/tcp, 8400/tcp, 8500/tcp, 8301-8302/udp, 8600/tcp, 8600/udp                 node8
4a1da1ea9a9e        gliderlabs/consul-agent:0.6    "/bin/consul agent -c"   14 seconds ago      Up 6 seconds        8300-8302/tcp, 8400/tcp, 8301-8302/udp, 8500/tcp, 8600/tcp, 8600/udp                 node7
41b421314918        gliderlabs/consul-agent:0.6    "/bin/consul agent -c"   15 seconds ago      Up 7 seconds        8300-8302/tcp, 8400/tcp, 8500/tcp, 8301-8302/udp, 8600/udp, 8600/tcp                 node6
a741a00a72f7        gliderlabs/consul-agent:0.6    "/bin/consul agent -c"   16 seconds ago      Up 8 seconds        8300-8302/tcp, 8400/tcp, 8500/tcp, 8301-8302/udp, 8600/tcp, 8600/udp                 node5
44c57e95fa79        gliderlabs/consul-agent:0.6    "/bin/consul agent -c"   3 minutes ago       Up 2 minutes        8300-8302/tcp, 8400/tcp, 8500/tcp, 8301-8302/udp, 8600/udp, 8600/tcp                 node4
49b6ad18b159        gliderlabs/consul-server:0.6   "/bin/consul agent -s"   4 minutes ago       Up 3 minutes        8300-8302/tcp, 8400/tcp, 8301-8302/udp, 8500/tcp, 8600/tcp, 8600/udp                 node3
569f41ca0e92        gliderlabs/consul-server:0.6   "/bin/consul agent -s"   4 minutes ago       Up 4 minutes        8300-8302/tcp, 8400/tcp, 8500/tcp, 8301-8302/udp, 8600/tcp, 8600/udp                 node2
a5354646a762        gliderlabs/consul-server:0.6   "/bin/consul agent -s"   6 minutes ago       Up 6 minutes        8300-8302/tcp, 8301-8302/udp, 8400/tcp, 8600/tcp, 8600/udp, 0.0.0.0:8500->8500/tcp   node1
```

## check clustering
```
$ docker exec -it node9 /bin/sh
/ # consul members
Node   Address           Status  Type    Build  Protocol  DC
node1  172.17.0.2:8301   alive   server  0.6.0  2         dc1
node2  172.17.0.3:8301   alive   server  0.6.0  2         dc1
node3  172.17.0.4:8301   alive   server  0.6.0  2         dc1
node4  172.17.0.5:8301   alive   client  0.6.0  2         dc1
node5  172.17.0.6:8301   alive   client  0.6.0  2         dc1
node6  172.17.0.7:8301   alive   client  0.6.0  2         dc1
node7  172.17.0.8:8301   alive   client  0.6.0  2         dc1
node8  172.17.0.9:8301   alive   client  0.6.0  2         dc1
node9  172.17.0.10:8301  alive   client  0.6.0  2         dc1
```
Getting docker machine IP `docker-machine ip default`, Access to `<docker machine IP>:8500` by your blower.

