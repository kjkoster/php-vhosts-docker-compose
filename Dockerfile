FROM php:8.0-apache

COPY ./sites/first.example.com/ /var/www/first.example.com/
COPY ./apache/config/first.example.com.conf /etc/apache2/sites-available/
COPY ./sites/second.example.com/ /var/www/second.example.com/
COPY ./apache/config/second.example.com.conf /etc/apache2/sites-available/

RUN a2ensite first.example.com.conf second.example.com.conf

