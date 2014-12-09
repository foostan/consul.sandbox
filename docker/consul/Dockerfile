FROM ubuntu:trusty

MAINTAINER foostan ks@fstn.jp

RUN apt-get update && apt-get install -y wget curl unzip telnet dnsutils

# install consul & consul tools
RUN mkdir consul
ADD config /consul/config

## consul
RUN wget -P /tmp https://dl.bintray.com/mitchellh/consul/0.4.1_linux_amd64.zip
RUN unzip /tmp/0.4.1_linux_amd64.zip -d /tmp
RUN mv /tmp/consul /usr/bin

## consul web ui
RUN wget -P /tmp https://dl.bintray.com/mitchellh/consul/0.4.1_web_ui.zip
RUN unzip /tmp/0.4.1_web_ui.zip -d /tmp
RUN mv /tmp/dist /consul/ui

## consul-template
RUN wget -P /tmp https://github.com/hashicorp/consul-template/releases/download/v0.3.1/consul-template_0.3.1_linux_amd64.tar.gz
RUN tar xvzf /tmp/consul-template_0.3.1_linux_amd64.tar.gz -C /tmp
RUN mv /tmp/consul-template_0.3.1_linux_amd64/consul-template /usr/bin

## consul-replicate
RUN wget -P /tmp https://github.com/hashicorp/consul-replicate/releases/download/v0.1.0/consul-replicate_linux_amd64
RUN mv /tmp/consul-replicate_linux_amd64 /usr/bin/consul-replicate
RUN chmod +x /usr/bin/consul-replicate

## envconsul
RUN wget -P /tmp https://github.com/hashicorp/envconsul/releases/download/v0.3.0/envconsul_0.3.0_linux_amd64.tar.gz
RUN tar xvzf /tmp/envconsul_0.3.0_linux_amd64.tar.gz -C /tmp
RUN mv /tmp/envconsul_0.3.0_linux_amd64/envconsul /usr/bin
