#!/bin/bash

add_gcloud_apt_repository(){
apt-get update
apt-get install sudo curl -y
# Create an environment variable for the correct distribution
export CLOUD_SDK_REPO="cloud-sdk-xenial"

# Add the Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
}

install_gcloud(){
# Update the package list and install the Cloud SDK
sudo apt-get update && sudo apt-get install google-cloud-sdk=180.0.1-0 -y
}

configure_gcloud(){
gcloud auth activate-service-account --key-file ${HOME}/gcp-key.json
gcloud --quiet config set project ${PROJECT_ID}
}

deploy_change(){
gcloud compute project-info add-metadata --metadata build_commit=${CIRCLE_SHA1}
gcloud beta compute instance-groups managed rolling-action replace lmap-api-instance-group --max-surge=3 --max-unavailable=0 --min-ready=200 --region=europe-west3
}

main(){
  add_gcloud_apt_repository
  install_gcloud
  configure_gcloud
  deploy_change
}
main
