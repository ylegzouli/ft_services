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
    cp srcs/mysql/wordpress.sql srcs/mysql/wordpress_target.sql
    sed -i '' "s/##MINIKUBE_IP##/$MINIKUBE_IP/g" srcs/mysql/wordpress_target.sql
    cp srcs/telegraf/telegraf.conf srcs/telegraf/telegraf-target.conf
    sed -i '' "s/##MINIKUBE_IP##/$MINIKUBE_IP/g" srcs/telegraf/telegraf-target.conf

    cp srcs/wordpress/wp-config.php srcs/wordpress/wp-config.php.new
	sed -i '' "s/##MINIKUBE_IP##/$MINIKUBE_IP/g" srcs/wordpress/wp-config.php.new
# ------------------------------------------------------------------------------------

	kubectl delete -k srcs

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

# Test ssh:
#ssh ylegzoul@$MINIKUBE_IP -p 30022

# Kill mysql:
# kubectl exec -it $(kubectl get pods | grep mysql | cut -d" " -f1) -- /bin/sh -c "kill 1"

# Acces:
# phpmyadmin: 5000   root root
# wordpress: 5050 ylegzoul 1234
# grafana: 3000 
# ftps: 21 ylegzoul 1234
# ssh: 30022 ylegzoul 1234

# Save grafana.db:
# kubectl cp grafana-deployment-c4bcbd76c-9tj8p:/grafana-6.6.0/data/grafana.db grafana.db


# ------------------------------------------------------------------------------------

