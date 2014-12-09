FROM ubuntu:trusty

MAINTAINER foostan ks@fstn.jp

RUN apt-get update
RUN apt-get install -y wget curl unzip telnet dnsutils

# install consul
RUN wget https://dl.bintray.com/mitchellh/consul/0.4.1_linux_amd64.zip
RUN unzip 0.4.1_linux_amd64.zip
RUN mv consul /usr/bin
ADD consul consul

# setup tinymemo
RUN apt-get install -y ruby
RUN gem install bundler
ADD tinymemo tinymemo
WORKDIR tinymemo
RUN bundle install

#EXPOSE 80
#ENTRYPOINT bundle exec ruby tinymemo.rb
