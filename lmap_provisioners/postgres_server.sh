#!/bin/bash
# This script automates the installation of postgresql on an Ubuntu-xenial linux machine.

install_pg(){
sudo apt-get update; sudo apt-get -y install postgresql postgresql-client postgresql-contrib
}

create_user(){
sudo -u postgres psql postgres -c "alter user postgres with encrypted password 'postgres'"
}

install_adminpack(){
sudo -u postgres psql postgres -c "CREATE EXTENSION adminpack"
}

allow_connection(){
pg_hba_file="/etc/postgresql/9.5/main/pg_hba.conf"
sudo echo "host    all             all           0.0.0.0/0         md5" >> ${pg_hba_file}


postgres_file="/etc/postgresql/9.5/main/postgresql.conf"
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" ${postgres_file}
}

restart_pg(){
sudo service postgresql restart
echo ".........Postgres successfully installed………."
}

main(){
  install_pg
  create_user
  install_adminpack
  allow_connection
  restart_pg
}
main
