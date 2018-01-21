#!/bin/bash -e
# This script automates the installation of postgresql on an Ubuntu-xenial linux machine.

install_pg(){
sudo apt-get update; sudo apt-get -y install postgresql postgresql-client postgresql-contrib
}

create_user(){
sudo -u postgres psql postgres -c "alter user postgres with encrypted password '$1'"
sudo -u postgres psql postgres -c "CREATE ROLE barmanstreamer WITH REPLICATION SUPERUSER PASSWORD '$2' LOGIN"
}

install_adminpack(){
sudo -u postgres psql postgres -c "CREATE EXTENSION adminpack"
}

allow_connection(){
pg_hba_file="/etc/postgresql/9.5/main/pg_hba.conf"
sudo mv /tmp/pg_hba.conf ${pg_hba_file}
sudo chown postgres ${pg_hba_file}

postgres_file="/etc/postgresql/9.5/main/postgresql.conf"
sudo mv /tmp/postgresql.conf ${postgres_file}
sudo chown postgres ${postgres_file}

#We may as well copy the other scripts from here!
sudo mv /tmp/postgres-startup.sh /home/packer/postgres-startup.sh
sudo mv /tmp/postgresql.sh /home/packer/postgresql.sh
}

start_pg_onboot(){
sudo systemctl enable postgresql
}

main(){
  install_pg
  create_user $1 $2
  install_adminpack
  allow_connection
  start_pg_onboot
}
main $1 $2
