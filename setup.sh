minikube start --vm-driver=virtualbox \
--cpus 3 --disk-size=30000mb --memory=3000mb \
--extra-config=apiserver.service-node-port-range=1-32767

minikube addons enable metrics-server
minikube addons enable ingress
# eval $(minikube docker-env)

KUB_IP=$(minikube ip)
cp srcs/ftps/vsftpd.conf_model srcs/ftps/vsftpd.conf
sed -i '' "s/##KUB_IP##/$KUB_IP/g" srcs/ftps/vsftpd.conf
cp srcs/wordpress/wordpress_model.sql srcs/wordpress/wordpress.sql
sed -i '' "s/##KUB_IP##/$KUB_IP/g" srcs/wordpress/wordpress.sql

#	helm install -f srcs/influxdb.yaml influxdb stable/influxdb
#    wait_for_deploy influxdb

#   helm install -f srcs/grafana.yaml grafana stable/grafana
#    wait_for_deploy grafana

docker build -t nginx_ssh srcs/nginx
docker build -t ftps_server srcs/ftps
docker build -t custom-wordpress:1.9 srcs/wordpress
docker build -t custom-phpmyadmin:1.1 srcs/phpmyadmin
docker build -t custom-mysql:1.11 srcs/mysql

kubectl apply -k srcs

echo "The minikube ip is : $KUB_IP"

# minikube dashboard

# Wordpress (port 5050) | PhpMyAdmin (port 5000) | Grafana (port 3000, username: admin, pwd: admin)



# --------------------



# 2.3) SSH connexion to the nginx service should work (pwd: password, cf Dockerfile)
# export KUB_IP=$(minikube ip)
# ssh -v root@$KUB_IP -p 32022

# 2.4) FTPS Server (in the FTPS Service)
# Put a file using filezilla (ip=$KUB_IP,user=admin,pwd=pass1234,port=21), 
# Then :
# export POD=$(kubectl get pod | grep ftps | cut -d" " -f1)
# echo "ls /ftps/data/admin" | (kubectl exec -it $POD -- /bin/sh)

# --------------------
# 3) Optional

# 3.1) Update html and see the result in Chrome
# kubectl get pod
# export POD=nginx-5c47d4568b-ptrgg   (replace it by your nginx pod name)
# kubectl cp srcs/nginx/index.html $POD:/usr/share/nginx/html/

# 3.2) change a config file and restart a service
# kubectl get pod
# export POD=...
# kubectl cp path_to_file $POD:folder_in_pod
# kubectl exec -it $POD -- /bin/sh
# sudo systemctl restart ...
