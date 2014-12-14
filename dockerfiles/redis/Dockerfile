FROM foostan/consul-playground-consul

MAINTAINER foostan ks@fstn.jp

## setup redis-server
RUN apt-get install -y redis-server

## setup supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 6379
CMD /usr/bin/supervisord
