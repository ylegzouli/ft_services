#FROM wordpress:php7.4-fpm-alpine
FROM alpine:latest

RUN apk update && apk add wget && mkdir /www \
&& apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session

RUN wget https://wordpress.org/latest.tar.gz \
&& tar -xvf latest.tar.gz \
&& mv wordpress/* /www \
&& rm -rf /var/cache/apk/*

COPY wp-config.php.new /www/wp-config.php
#COPY setup.sh .

#RUN chmod +x setup.sh

RUN apk update && \
	apk add nginx mysql-client

COPY nginx.conf /etc/nginx/nginx.conf
COPY wordpress_target.sql /wordpress.sql
COPY entrypoint /entrypoint

EXPOSE 5050

ENTRYPOINT sh /entrypoint
