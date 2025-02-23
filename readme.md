# PHP and Virtual Hosts using Docker Compose

This is yet another example project that shows how to set up PHP in a Docker
container. It has a couple of features that many others may not have.

The project packs the complete set of PHP-enabled websites into the image for
production use. The same image can be used on a development or test server,
ensuring that what is tested is also what is going live.

The Apache log directory is mounted from the host, so that these are avvailable
for troubleshooting.

## Running on Production

This image was designed for production use, so we can simply start it on the
production server using:

```sh
docker-compose up
```

This assumes that the DNS is configured to send traffic for the various virtual
hosts to the IP address of the production server.

## Running Locally for Development

For local development, first make sure that the host names of the virtual
servers resolve to `localhost`. For that, edit `/etc/hosts` with your favourite
editor, adding lines as follows:

```
127.0.0.1 first.example.com
127.0.0.1 second.example.com
```

You can verify that this works using `ping`. Check that the IP address for the
virtual hosts resolve to `127.0.0.1`.

```sh
$ ping first.example.com
PING first.example.com (127.0.0.1): 56 data bytes
64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=0.096 ms
64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.269 ms
^C
```

With that in place, you can start the local server using:

```sh
docker-compose up --build
```

The `--build` flag tells Docker Compose to rebuild the image and recreate the
container, so that changes will be picked up.

## Reference

It is probably useful to know what paths the Apache and PHP components can be
found at inside the container. Tutorials use a variety of Docker images. Apache
and PHP may be shown using slightly different paths each time. Here is what the
official PHP image uses:

- PHP:
    - configuration: /usr/local/etc/php/conf.d/
- Apache:
    - configuration: /etc/apache2/
    - log files: /var/log/apache2/

- [Official PHP Docker Image](https://hub.docker.com/_/php) I chose to use the
  official PHP image instead of rolling my own or using the official Apache
  image, because this yields the smallest and simplest `Dockerfile`.
- [How to Serve PHP Websites Locally using Docker and Apache](https://www.youtube.com/watch?v=aAwBSuldn_U)
  by [JoseCanHelp](https://www.youtube.com/@JoseCanHelp) Nice step-by-step.
  Helped me get started and gave me some ideas, but I ended up not using it,
  mostly.
- [Virtual Apache SSL Hosts in a Docker Container](https://www.fogbound.net/archives/2021/07/09/virtual-apache-ssl-hosts-in-a-docker-container/)
  by [Samuel Goldstein](https://www.fogbound.net/who-am-i/) Useful because it
  explains both virtual hosts and SSL. You will see that I have adapted from
  his example quite a bit.
