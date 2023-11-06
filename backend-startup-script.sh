#! /bin/bash
# updating the apt-get package 

apt update
# installing nodejs
apt install nginx -y
apt install nodejs -y
# installing npm
apt install npm -y 


mkdir /app
cd /app

# copying the app files from cloud storage to gce instance
gsutil cp -r gs://race-gce-files/app/* .
# installing process manager module to automate the deployment process
npm i -g pm2
npm i 
export DATABASE=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/database -H "Metadata-Flavor: Google")
sed -i "s/DATABASE_IP_ADDRESS/${DATABASE}/g" server.js
pm2 start server.js --name todo 
# copying the nginx.conf file from cloud storage to required location
# this enables nginx to act as a reverse proxy on port 80 and serve nodejs  website as a response
gsutil cp gs://race-gce-files/config/nginx.conf /etc/nginx/nginx.conf
# restarting the nginx service to reflect the changes
service nginx restart
