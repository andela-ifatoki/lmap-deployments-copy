#!/bin/bash -e

create_ssh_keys(){
  ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
}

set_metadata(){
  gcloud beta compute project-info add-metadata --metadata-from-file=barman_public_key=/var/lib/barman/.ssh/id_rsa.pub
}

fetch_main_db_keys(){
  while true
  do
    main_db_keys=$(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/main_db_public_key -H "Metadata-Flavor: Google" --fail)
    if [ $? -eq 0 ]; then
      echo ${main_db_keys} >> /var/lib/barman/.ssh/authorized_keys
      chmod 600 /var/lib/barman/.ssh/authorized_keys
      break
    fi
    sleep 3
  done
}
run_cronjob(){
  sleep 300
  barman receive-wal --create-slot main-lmap-db
  crontab -u barman /home/packer/db-backup-cronjob
}

main(){
  create_ssh_keys
  set_metadata
  fetch_main_db_keys
  run_cronjob
}
main
