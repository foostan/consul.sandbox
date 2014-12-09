tinymemo
========
This is a very simple memo application.

Screen shot
------------
![ScreenShot](./docs/images/screen_shot.png)

Starting tinymemo
------------
```
$ docker run -d --dns=127.0.0.1 -e "CONSUL_OPT=-server -bootstrap" foostan/consul-playground-tinymemo
```
