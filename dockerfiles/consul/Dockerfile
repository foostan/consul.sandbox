FROM ubuntu:trusty

MAINTAINER foostan ks@fstn.jp

RUN apt-get update && apt-get install -y wget curl unzip telnet dnsutils
RUN wget http://stedolan.github.io/jq/download/linux64/jq
RUN chmod +x jq
RUN mv jq /usr/bin

# install consul & consul tools
RUN mkdir consul
ADD config /consul/config

## consul
RUN wget -P /tmp https://dl.bintray.com/mitchellh/consul/0.5.0_linux_amd64.zip
RUN unzip /tmp/0.5.0_linux_amd64.zip -d /tmp
RUN mv /tmp/consul /usr/bin

## consul web ui
RUN wget -P /tmp https://dl.bintray.com/mitchellh/consul/0.5.0_web_ui.zip
RUN unzip /tmp/0.5.0_web_ui.zip -d /tmp
RUN mv /tmp/dist /consul/ui

## consul-template
RUN wget -P /tmp https://github.com/hashicorp/consul-template/releases/download/v0.7.0/consul-template_0.7.0_linux_amd64.tar.gz
RUN tar xvzf /tmp/consul-template_0.7.0_linux_amd64.tar.gz -C /tmp
RUN mv /tmp/consul-template_0.7.0_linux_amd64/consul-template /usr/bin

## consul-replicate
RUN wget -P /tmp https://github.com/hashicorp/consul-replicate/releases/download/v0.1.0/consul-replicate_linux_amd64
RUN mv /tmp/consul-replicate_linux_amd64 /usr/bin/consul-replicate
RUN chmod +x /usr/bin/consul-replicate

## envconsul
RUN wget -P /tmp https://github.com/hashicorp/envconsul/releases/download/v0.5.0/envconsul_0.5.0_linux_amd64.tar.gz
RUN tar xvzf /tmp/envconsul_0.5.0_linux_amd64.tar.gz -C /tmp
RUN mv /tmp/envconsul_0.5.0_linux_amd64/envconsul /usr/bin
