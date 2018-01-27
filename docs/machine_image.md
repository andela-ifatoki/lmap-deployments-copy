# Image Creation

## Tech Stack
- Packer - version 1.1.3 was used for this project

## Building a base image for Learning Map API infrastructure

> **Note:**
The instructions below already assume that
> - This repository has been cloned to your local machine.
> - You have an account on google cloud platform, with the project on which Learning Map API is being deployed to.
> - You have a service account with at least admin capabilities of Compute Image User, Compute Instance Admin and Service Account Actor.

### Step 1
Create a key for the service account, and place it at the root of the repository. Rename the file to gcp-account.json.

### Step 2
Change directory to the packer/templates directory.  
`cd packer/templates`

### Step 3
Provide the value for the following environmental variables:

`PROJECT_ID`: The Project ID on GCP to which the generated environment key belongs.  
`export PROJECT_ID=<your-project-id>`

`DB_PASSWORD`: The password of the user the main database will be accessed through.  
`export DB_PASSWORD=<password>`

`STREAMER_PASSWORD`: The password of the user Barman will use to backup the main database  
`export STREAMER_PASSWORD=<password>`

### Step 4
Run the command below for every template file to ensure that it is valid. The command should give back a message response indicating successful validation.

`packer validate xxx-pckr-tmplt.json`

### Step 5
Build the packer images with the following command

`packer build xxx-pckr-tmplt.json`
