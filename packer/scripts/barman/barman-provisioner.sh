#/bin/bash -e

#Add Postgresql apt-repository
add_apt_repository(){
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7FCC7D46ACCC4CF8
  sudo apt-get update
}

install_barman(){
  sudo apt-get install barman -y
}

copy_config_files(){
  sudo mv /tmp/barman.conf /etc/barman.conf
  sudo mv /tmp/db-backup-cronjob /home/packer/db-backup-cronjob
  sudo mv /tmp/barman-startup.sh /home/packer/barman-startup.sh
  sudo mv /tmp/barman.sh /home/packer/barman.sh
}

main(){
  add_apt_repository
  install_barman
  copy_config_files
}
main
