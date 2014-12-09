FROM ubuntu:trusty

MAINTAINER foostan ks@fstn.jp

RUN apt-get update && apt-get install -y wget curl unzip telnet dnsutils

# install consul & consul tools
mkdir consul
WORKDIR consul
ADD config .

## consul
RUN wget https://dl.bintray.com/mitchellh/consul/0.4.1_linux_amd64.zip
RUN unzip 0.4.1_linux_amd64.zip
RUN mv consul /usr/bin

## consul web ui
RUN wget https://dl.bintray.com/mitchellh/consul/0.4.1_web_ui.zip
RUN unzip 0.4.1_web_ui.zip
RUN mv dist ui

## consul-template
RUN wget https://github.com/hashicorp/consul-template/releases/download/v0.3.1/consul-template_0.3.1_linux_amd64.tar.gz
RUN tar xzf consul-template_0.3.1_linux_amd64.tar.gz
RUN mv consul-template_0.3.1_linux_amd64/consul-template /usr/bin

## consul-replicate
RUN wget https://github.com/hashicorp/consul-replicate/releases/download/v0.1.0/consul-replicate_linux_amd64
RUN mv consul-replicate_linux_amd64 /usr/bin/consul-replicate
RUN chmod +x /usr/bin/consul-replicate

## envconsul
RUN wget https://github.com/hashicorp/envconsul/releases/download/v0.3.0/envconsul_0.3.0_linux_amd64.tar.gz
RUN tar xzf envconsul_0.3.0_linux_amd64.tar.gz
RUN mv envconsul_0.3.0_linux_amd64/envconsul /usr/bin
