FROM alpine:latest

# VOLUME /var/run/docker.sock:/var/run/docker.sock

# Installing
RUN apk update ; \
	apk add mariadb mariadb-client && apk add --no-cache --upgrade bash ; \
	rm -rf /var/cache/apk/*

# Copying script and my wordpress database
COPY ./init_docker.sh .
COPY ./init_mysql.sh .
COPY wordpress_target.sql .

RUN chmod 777 init_docker.sh
RUN chmod 777 init_mysql.sh

EXPOSE 3306

# Starting script
ENTRYPOINT [ "./init_docker.sh" ]
