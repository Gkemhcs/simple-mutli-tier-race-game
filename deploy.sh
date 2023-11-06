#! /bin/bash
echo "ENTER YOUR PROJECT ID"
read PROJECT_ID
gcloud services enable compute.googleapis.com iam.googleapis.com cloudresourcemanager.googleapis.com \
sqladmin.googleapis.com servicenetworking.googleapis.com
echo "ENTER THE NAME OF YOUR GCS BUCKET TO CREATE"
echo -e "\e[93m THE NAME OF BUCKET MUST BE UNIQUE.\e[0m"
read BUCKET_NAME 
sed -i "s/PROJECT_ID/${PROJECT_ID}/g" terraform-files/vars.auto.tfvars
sed -i "s/BUCKET_NAME/${BUCKET_NAME}/g" terraform-files/vars.auto.tfvars
terraform apply -auto-approve
gcloud sql connect sql-race-game --user root < database.sql