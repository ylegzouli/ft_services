#!/bin/sh

export MINIKUBE_HOME=~/goinfre/

minikube start --vm-driver=virtualbox \
	--cpus 3 --disk-size=30000mb --memory=3000mb \
	--extra-config=apiserver.service-node-port-range=1-31000
    
minikube addons enable ingress
minikube addons enable metrics-server

# ------------------------------------------------------------------------------------

export MINIKUBE_IP=$(minikube ip)

    cp -f srcs/ftps/vsftpd_sub.conf srcs/ftps/vsftpd.conf
    sed -i '' "s/##MINIKUBE_IP##/$MINIKUBE_IP/g" srcs/ftps/vsftpd.conf
    cp srcs/wordpress/wordpress_dump.sql srcs/wordpress/wordpress_dump-target.sql
    sed -i '' "s/##MINIKUBE_IP##/$MINIKUBE_IP/g" srcs/wordpress/wordpress_dump-target.sql
    cp srcs/telegraf/telegraf.conf srcs/telegraf/telegraf-target.conf
    sed -i '' "s/##MINIKUBE_IP##/$MINIKUBE_IP/g" srcs/telegraf/telegraf-target.conf

# ------------------------------------------------------------------------------------

eval $(minikube docker-env)

	docker build -t my-nginx srcs/nginx
	docker build -t my-ftps srcs/ftps
	docker build -t my-mysql srcs/mysql
	docker build -t my-phpmyadmin srcs/phpmyadmin
	docker build -t my-wordpress srcs/wordpress
	docker build -t my-grafana srcs/grafana

	kubectl apply -k srcs

# ------------------------------------------------------------------------------------

#minikube dashboard
#ssh root@$MINIKUBE_IP -p 30022
#cat /etc/issue

# phpmyadmin: 5000
# wordpress: 5050
# grafana: 3000
# 192.168.99.131

# ------------------------------------------------------------------------------------

