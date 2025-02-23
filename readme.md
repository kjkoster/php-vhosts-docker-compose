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

Once the image was built and the container is running, you can open your web
browser and open the URL http://first.example.com to access the application.

## Running Locally, for Development

For local development, first make sure that the host names of the virtual
servers resolve to `localhost`. For that, edit `/etc/hosts` with your favourite
editor, adding lines as follows:

```
127.0.0.1 first.local
127.0.0.1 second.local
```

You can verify that this works using `ping`. Check that the IP address for the
virtual hosts resolve to `127.0.0.1`.

```sh
$ ping first.local
PING first.local (127.0.0.1): 56 data bytes
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

Once the image was built and the container is running, you can open your web
browser and open the URL http://first.local to access the application.

There is some risk involved in using a different domain during development. Your
code may have URLs with the production domain name hardcoded. In that case, you
can end up in the situation where some traffic escapes and calls out to the
production server. To trap such cases, set your development machine to route
traffic to a non-existent IP address. Here we use `127.0.0.2`. That is not an
officially recognised way of doing that, but it works in most cases. The
hardcoded URLs now show up as errors in your web browser development tools.

```
127.0.0.1 first.local
127.0.0.1 second.local

127.0.0.2 first.example.com
127.0.0.2 second.example.com
```

Note the use of `.2` instead of the more typical `.1` at the end.

There is no support for wildcards in `/etc/hosts`, so you will have to be
careful to list each and every one of your subdomains separately. Once done,
check that traffic to your main domain is now blocked on your development
machine:

```
$ curl -v --connect-timeout 1 first.example.com
* Host first.example.com:80 was resolved.
* IPv6: (none)
* IPv4: 127.0.0.2
*   Trying 127.0.0.2:80...
* ipv4 connect timeout after 998ms, move on!
* Failed to connect to first.example.com port 80 after 1007 ms: Timeout was reached
* Closing connection
curl: (28) Failed to connect to first.example.com port 80 after 1007 ms: Timeout was reached
```

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
