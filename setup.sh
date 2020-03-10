#!/bin/sh

export MINIKUBE_HOME=~/goinfre/

#minikube start \
minikube start --vm-driver=virtualbox \
	--cpus 3 --disk-size=30000mb --memory=3000mb \
	--extra-config=apiserver.service-node-port-range=1-31000

minikube addons enable dashboard    
minikube addons enable ingress
minikube addons enable metrics-server

# ------------------------------------------------------------------------------------

export MINIKUBE_IP=$(minikube ip)

    cp -f srcs/ftps/vsftpd_sub.conf srcs/ftps/vsftpd.conf
    sed -i '' "s/##MINIKUBE_IP##/$MINIKUBE_IP/g" srcs/ftps/vsftpd.conf
    cp srcs/wordpress/wordpress.sql srcs/wordpress/wordpress_target.sql
    sed -i '' "s/##MINIKUBE_IP##/$MINIKUBE_IP/g" srcs/wordpress/wordpress_target.sql
    cp srcs/telegraf/telegraf.conf srcs/telegraf/telegraf-target.conf
    sed -i '' "s/##MINIKUBE_IP##/$MINIKUBE_IP/g" srcs/telegraf/telegraf-target.conf

# ------------------------------------------------------------------------------------

	kubeclt delete -k srcs

eval $(minikube docker-env)

	docker build -t ylegzoul/nginx srcs/nginx
	docker build -t ylegzoul/ftps srcs/ftps
	docker build -t ylegzoul/mysql srcs/mysql
	docker build -t ylegzoul/phpmyadmin srcs/phpmyadmin
	docker build -t ylegzoul/wordpress srcs/wordpress
	docker build -t ylegzoul/grafana srcs/grafana

	kubectl apply -k srcs

# ------------------------------------------------------------------------------------

#minikube dashboard
#ssh root@$MINIKUBE_IP -p 30022
#cat /etc/issue

#kill mysql
# kubectl exec -it $(kubectl get pods | grep mysql | cut -d" " -f1) -- /bin/sh -c "kill 1"

# phpmyadmin: 5000
# wordpress: 5050
# grafana: 3000

# ------------------------------------------------------------------------------------

