FROM php:8.0-apache

COPY ./sites/first.example.com/ /var/www/first.example.com/
COPY ./apache/config/first.example.com.conf /etc/apache2/sites-available/
COPY ./sites/second.example.com/ /var/www/second.example.com/
COPY ./apache/config/second.example.com.conf /etc/apache2/sites-available/

COPY ./ssl.crt /etc/apache2/ssl/ssl.crt
COPY ./ssl.key /etc/apache2/ssl/ssl.key

# These are set in your `docker-compose.yml`, which loads them from your `.env`.
ENV MYSQL_HOST "not-set"
ENV MYSQL_USER "not-set"
ENV MYSQL_PASS "not-set"

RUN a2enmod ssl rewrite && a2ensite first.example.com.conf second.example.com.conf
