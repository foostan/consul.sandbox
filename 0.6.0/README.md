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

If you use some commands in each containers, execute `apk add <package-name>`.
```
/ # apk add jq
/ # apk add bind-tools
```

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

## features
### Network Tomography

`consul rtt` command
```
# Get the estimated RTT from current node to another
/ # consul rtt node1
Estimated node1 <-> node9 rtt: 0.107 ms (using LAN coordinates)

# Get the estimated RTT between two other nodes from a third node
/ # consul rtt node1 node2
Estimated node1 <-> node2 rtt: 0.042 ms (using LAN coordinates)
```

`?near=` query
```
Estimated node2 <-> node1 rtt: 0.066 ms (using LAN coordinates)
/ # consul rtt node2 node2
Estimated node2 <-> node2 rtt: 0.020 ms (using LAN coordinates)
/ # consul rtt node2 node3
Estimated node2 <-> node3 rtt: 0.218 ms (using LAN coordinates)

# Get a list of healthy nodes providing the "consul" service sorted
# relative to a specific node by RTT
/ # curl localhost:8500/v1/health/service/consul?passing&near=node2 | jq -r '.[].Node.Node'
node2
node1
node3

# Get the full list of nodes sorted relative to a specific node by RTT
/ # curl localhost:8500/v1/catalog/nodes?near=node5 | jq -r '.[].Node'
node5
node1
node9
node2
node8
node7
node6
node4
node3
```

`/v1/coordinate/nodes?pretty`
```
[
    {
        "Node": "node1",
        "Coord": {
            "Vec": [
                0.0008308362555119787,
                3.8834696349342976e-05,
                -7.330295628680596e-05,
                4.8062527310734514e-05,
                -0.0005581071597177744,
                -0.0003221936982394534,
                -6.971672661372596e-05,
                -0.0004306435811588809
            ],
            "Error": 1.5,
            "Adjustment": -0.00011494860634112172,
            "Height": 1e-05
        }
    },
    {
        "Node": "node2",
        "Coord": {
            "Vec": [
                0.0009838237474445097,
                -8.948185219298897e-05,
                -0.0001975770907099398,
                -0.00010850758409038799,
                -0.00047155927265006775,
                -0.0003061645607253343,
                -0.00010680739481578534,
                -0.00038532602975600936
            ],
            "Error": 0.3718403628578162,
            "Adjustment": -7.270959866839972e-05,
            "Height": 1.3393634886322704e-05
        }
    },
    {
        "Node": "node3",
        "Coord": {
            "Vec": [
                0.0007790221967808862,
                6.914188380807579e-05,
                7.062968132664298e-05,
                0.00032544947802519176,
                -0.0006541842810516811,
                -0.0005631915374662459,
                -8.950215112117045e-05,
                -0.0006292580762066054
            ],
            "Error": 0.7817148091744002,
            "Adjustment": -2.1750939565216435e-05,
            "Height": 1.7306613773018416e-05
        }
    },
    {
        "Node": "node4",
        "Coord": {
            "Vec": [
                0.0007750088234166339,
                -6.648183921543096e-05,
                6.595850650451458e-05,
                4.476915104072036e-05,
                -0.0005330333440500301,
                -0.0003396976765792745,
                -0.00018009025741683393,
                -0.0003354371244755442
            ],
            "Error": 0.4662724272241323,
            "Adjustment": -8.246895358696942e-05,
            "Height": 1.3124720777974974e-05
        }
    },
    {
        "Node": "node5",
        "Coord": {
            "Vec": [
                0.0008756082448597619,
                0.0001451495962603484,
                -0.00016348329520411183,
                -7.421255884312142e-06,
                -0.0006111789589409528,
                -0.00022696220959236607,
                -4.21740756687009e-05,
                -0.00037307546522279556
            ],
            "Error": 0.6239200064902178,
            "Adjustment": -8.412713268872293e-05,
            "Height": 3.4543520155739374e-05
        }
    },
    {
        "Node": "node6",
        "Coord": {
            "Vec": [
                0.0007933796817663052,
                4.983046470566237e-05,
                -9.702838552304187e-05,
                3.040296448700226e-05,
                -0.0005264474847280151,
                -0.0002941232682663392,
                -6.820691953143878e-05,
                -0.0003872869858185183
            ],
            "Error": 0.1887715382026358,
            "Adjustment": -6.819567824840735e-05,
            "Height": 5.0365606598955985e-05
        }
    },
    {
        "Node": "node7",
        "Coord": {
            "Vec": [
                0.0009350777191959045,
                4.499505796461562e-05,
                3.915480990138882e-05,
                -1.1579372878324448e-05,
                -0.0007258365876150744,
                -0.0003179427728042287,
                -7.793465386253961e-05,
                -0.0004676110246087647
            ],
            "Error": 0.5423866972713568,
            "Adjustment": -5.6858658839466216e-05,
            "Height": 3.005228399338976e-05
        }
    },
    {
        "Node": "node8",
        "Coord": {
            "Vec": [
                0.0008241239131583833,
                1.998265731794065e-05,
                -0.00011906286207585868,
                1.960936999867024e-05,
                -0.0005031235742582041,
                -0.00031863387772168057,
                9.233626644673831e-05,
                -0.0006058093090722743
            ],
            "Error": 0.6215351125132542,
            "Adjustment": -7.72737362166153e-05,
            "Height": 4.3466618805655724e-05
        }
    },
    {
        "Node": "node9",
        "Coord": {
            "Vec": [
                0.0009366983301109099,
                4.9953759736052004e-05,
                -0.0001549760502726523,
                9.353780837133608e-05,
                -0.0005210341425697293,
                -0.00020805724862674042,
                -6.315174348245893e-05,
                -0.0004353838903282064
            ],
            "Error": 0.35291220381539484,
            "Adjustment": -6.71410964055522e-05,
            "Height": 1.019578519702038e-05
        }
    }
]
```
### Prepared Queries

```
/ # curl -X PUT localhost:8500/v1/agent/service/register -d '{
>   "ID": "app1",
>   "Name": "hoge-api",
>   "Tags": [
>     "api",
>     "v0.1.0"
>   ]
> }'
/ # curl -X PUT 172.17.0.3:8500/v1/agent/service/register -d '{
>   "ID": "app1",
>   "Name": "hoge-api",
>   "Tags": [
>     "api",
>     "v0.1.0"
>   ]
> }'
/ # curl -X PUT 172.17.0.5:8500/v1/agent/service/register -d '{
>   "ID": "app1",
>   "Name": "hoge-api",
>   "Tags": [
>     "api",
>     "v0.0.1"
>   ]
> }'
/ # curl localhost:8500/v1/catalog/service/hoge-api | jq -r '.[].Node'
node2
node4
node9
/ # curl -X POST -d \
> '{
>   "Name": "hoge-api-with-failover",
>   "Service": {
>     "Service": "hoge-api",
>     "Failover": {
>       "NearestN": 3
>     },
>     "Tags": ["api", "v0.1.0"]
>   },
>   "DNS": {
>     "TTL": "10s"
>   }
> }' localhost:8500/v1/query
{"ID":"cc72300b-946c-68a0-e744-e6f203719dd5"}/ #
/ # dig @127.0.0.1 -p 8600 hoge-api.service.consul. ANY
; <<>> DiG 9.10.3-P2 <<>> @127.0.0.1 -p 8600 hoge-api.service.consul. ANY
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 401
;; flags: qr aa rd; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 0
;; WARNING: recursion requested but not available

;; QUESTION SECTION:
;hoge-api.service.consul.   IN  ANY

;; ANSWER SECTION:
hoge-api.service.consul. 0  IN  A   172.17.0.10
hoge-api.service.consul. 0  IN  A   172.17.0.3
hoge-api.service.consul. 0  IN  A   172.17.0.5

;; Query time: 0 msec
;; SERVER: 127.0.0.1#8600(127.0.0.1)
;; WHEN: Thu Dec 17 11:24:48 UTC 2015
;; MSG SIZE  rcvd: 158

/ # dig @127.0.0.1 -p 8600 hoge-api-with-failover.query.consul. ANY

; <<>> DiG 9.10.3-P2 <<>> @127.0.0.1 -p 8600 hoge-api-with-failover.query.consul. ANY
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 7875
;; flags: qr aa rd; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 0
;; WARNING: recursion requested but not available

;; QUESTION SECTION:
;hoge-api-with-failover.query.consul. IN    ANY

;; ANSWER SECTION:
hoge-api-with-failover.query.consul. 10 IN A    172.17.0.10
hoge-api-with-failover.query.consul. 10 IN A    172.17.0.3

;; Query time: 0 msec
;; SERVER: 127.0.0.1#8600(127.0.0.1)
;; WHEN: Thu Dec 17 11:34:23 UTC 2015
;; MSG SIZE  rcvd: 155
```
