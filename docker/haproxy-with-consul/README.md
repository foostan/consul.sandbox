HAProxy with Consul
=======================
Make a Docker image of HAProxy, and it can change configuration by Consul Template.

Starting HAProxy
------------
```
$ docker run -d -p 80 -p 8080 -e "CONSUL_URI=localhost:8500" foostan/haproxy-with-consul
```
