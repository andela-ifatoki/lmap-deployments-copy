## Packer Build Guide

The packer image for the CALM Frontend app has been built and is available for use on [Google Cloud].(<https://console.cloud.google.com/compute/imagesDetail/projects/learning-map-app/global/images/lmap-frontend-packer-image?project=learning-map-app&organizationId=729171320006>
)
For editing purposes, this guide will go through how to build the image from this directory.

- Clone this repository by running `git clone https://github.com/andela/lmap-deployments.git` on your terminal
- Navigate into the packer directory by running `cd frontend/packer`
- Download the credentials for the learning map project on Google Cloud into this directory. The credentials file will be the value for the `account_file` key in `lmap-frontend-packer-image.json`
- Copy your ssh private key and save in this directory. The filename should be `id_rsa`. The id_rsa file will be the value for the source key in position 0 of the provisioners array in `lmap-frontend-packer-image.json`
- Run `packer build lmap-frontend-packer-image.json`




