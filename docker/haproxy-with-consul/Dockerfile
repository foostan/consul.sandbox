FROM ubuntu:trusty

MAINTAINER foostan ks@fstn.jp

RUN apt-get update

# install and setup HAProxy
RUN apt-get install haproxy
RUN sed -i -e 's/ENABLED=0/ENABLED=1/' /etc/default/haproxy

# install and setup Consul Template
RUN apt-get install -y wget
RUN wget https://github.com/hashicorp/consul-template/releases/download/v0.3.0/consul-template_0.3.0_linux_amd64.tar.gz
RUN tar xzf consul-template_0.3.0_linux_amd64.tar.gz
RUN mv consul-template_0.3.0_linux_amd64/consul-template /usr/bin
ADD haproxy.ctmpl /etc/haproxy/haproxy.ctmpl

EXPOSE 80
EXPOSE 8080

CMD consul-template -consul=$CONSUL_URI -template=/etc/haproxy/haproxy.ctmpl:/etc/haproxy/haproxy.cfg:"service haproxy reload"
