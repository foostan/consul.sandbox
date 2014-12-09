FROM foostan/consul-playground-consul

MAINTAINER foostan ks@fstn.jp

## setup tinymemo
RUN apt-get install -y ruby
RUN gem install bundler
ADD . /tinymemo
WORKDIR /tinymemo
RUN bundle install

## setup supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80
CMD /usr/bin/supervisord
