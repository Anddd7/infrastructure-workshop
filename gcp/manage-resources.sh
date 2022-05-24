gcloud compute instance-templates create lb-backend-template-2 \
   --network=default \
   --subnet=default \
   --tags=allow-health-check \
   --image-family=debian-9 \
   --image-project=debian-cloud \
   --metadata=startup-script=\#\!\ /bin/bash$'\n'apt-get\ update$'\n'apt-get\ install\ -y\ nginx$'\n'service\ nginx\ start$'\n'sed\ -i\ --\ \'s/nginx/Google\ Cloud\ Platform\ -\ \'\"\\\$HOSTNAME\"\'/\'\ /var/www/html/index.nginx-debian.html     


gcloud config set compute/region us-east1
gcloud config set compute/zone us-east1-b


gcloud compute instances create nucleus-jumphost-783 --machine-type=f1-micro

gcloud container clusters create mycluster
gcloud container clusters get-credentials mycluster
kubectl create deploy hello-app --image=gcr.io/google-samples/hello-app:2.0
kubectl expose deploy hello-app --type=LoadBalancer --port=8083


gcloud compute firewall-rules create grant-tcp-rule-114 \
    --network=default \
    --action=allow \
    --direction=ingress \
    --source-ranges=130.211.0.0/22,35.191.0.0/16 \
    --target-tags=allow-health-check \
    --rules=tcp:80