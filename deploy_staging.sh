#!/bin/bash

add_gcloud_apt_repository(){
# Create an environment variable for the correct distribution
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"

# Add the Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
}

install_gcloud(){
# Update the package list and install the Cloud SDK
sudo apt-get update && sudo apt-get install google-cloud-sdk -y
}

configure_gcloud(){
gcloud auth activate-service-account --key-file ${HOME}/gcp-key.json
gcloud --quiet config set project noob-183014
gcloud --quiet config set compute/zone us-east1-b
}

deploy_change(){
gcloud compute instances add-metadata api-server --metadata build_commit=${CIRCLE_SHA1}
gcloud compute instances stop api-server
gcloud compute instances start api-server
}

main(){
  add_gcloud_apt_repository
  install_gcloud
  configure_gcloud
  deploy_change  
}
main
