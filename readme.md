# PHP and Virtual Hosts using Docker Compose

This is yet another example project that shows how to set up PHP in a Docker
container. It has a couple of features that many others may not have.

For context, let's say that you have a bunch of websites that use PHP. For
simplicity I will assume that these websites are all under the `./sites/`
directory. You can add or change paths once you are familiar with the structure
of this project.

The example packs the complete set of PHP-enabled websites into the image for
production use. The same image can be used on a development or test server,
ensuring that what is tested is also what is going live.

For local development, the websites are mounted directly onto the file system in
the container. This means that file changes are picked up immediately, without
builds or restarts.

The Apache log directory is mounted from the host, so that these are available
for troubleshooting.

## Running on Production

This image was designed for production use, so we can start it on the production
server using:

```sh
docker compose -f docker-compose.yml up
```

Note how we explicity tell Docker Compose to use the base compose file. This
means that any overrides from `docker-compose.override.yml` are ignored on
production.

This assumes that the DNS is configured to send traffic for the various virtual
hosts to the IP address of the production server.

Once the image was built and the container is running, you can open your web
browser and open the URL http://first.example.com to access the application.

## Running Locally, for Development

For local development it is important to have a quicker cycle than to rebuild
images and restart containers all the time. This section explains how to set up
for local development and how to edit files locally without having to rebuild
and restart the container.

There is some risk in using a different domain during development. Your code may
have URLs with the production domain name hardcoded. When that is the case, you
can end up mixing connections to the local server with connections to the
production server. We will work around this problem by overriding the production
server's DNS settings in out local `/etc/hosts` file.

Edit `/etc/hosts` with your favourite editor, adding lines as follows:

```
127.0.0.1 first.example.com
127.0.0.1 second.example.com
```

There is no support for wildcards in `/etc/hosts`, so you will have to be
careful to list each and every one of your subdomains separately.

You can verify that this works using `ping`. Check that the IP address for the
virtual hosts resolve to `127.0.0.1`.

```sh
$ ping first.example.com
PING first.example.com (127.0.0.1): 56 data bytes
64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=0.096 ms
64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.269 ms
^C
```

With that in place, you can start the local server using the `--build` flag to
pick up any structural changes:

```sh
docker compose up --build
```

By omitting the `-f` flag that we needed on the production server, Docker
Compose loads both the base compose file, as well as
`docker-compose-override.yml`, in that order. You can view the resulting
configuration using:

```sh
docker compose config
```

Once the image was built and the container is running, you can open your web
browser and open the URL http://first.example.com to access the application on
the local development server.

## Reference

It is probably useful to know what paths the Apache and PHP components can be
found at inside the container. Tutorials use a variety of Docker images. Apache
and PHP may be shown using slightly different paths each time. Here is what the
official PHP image uses:

* PHP:
    - configuration: /usr/local/etc/php/conf.d/
* Apache:
    - configuration: /etc/apache2/
    - log files: /var/log/apache2/
    - www root: /var/www/

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
