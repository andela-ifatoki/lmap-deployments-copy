#!/bin/bash -e

create_ssh_keys(){
  ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
}

set_metadata(){
  gcloud beta compute project-info add-metadata --metadata-from-file=main_db_public_key=/var/lib/postgresql/.ssh/id_rsa.pub
}

fetch_barman_public_key(){
  while true
  do
    barman_public_key=$(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/barman_public_key -H "Metadata-Flavor: Google" --fail)
    if [ $? -eq 0 ]; then
      echo ${barman_public_key} >> /var/lib/postgresql/.ssh/authorized_keys
      chmod 600 /var/lib/postgresql/.ssh/authorized_keys
      break
    fi
    sleep 3
  done
}
main(){
  create_ssh_keys
  set_metadata
  fetch_barman_public_key
}
main
