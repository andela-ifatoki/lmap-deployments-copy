#!/bin/bash
# This script installs and runs Redis on an Ubuntu-xenial linux machine.

install_redis(){
sudo apt-get update; sudo apt-get install redis-server -y
}

allow_connection(){
redis_conf="/etc/redis/redis.conf"
sudo sed -i "s/bind 127.0.0.1/bind 0.0.0.0/g" ${redis_conf}
}

run_on_boot(){
sudo systemctl enable redis-server.service
}

restart(){
sudo systemctl restart redis-server.service
}

main(){
  install_redis
  allow_connection
  run_on_boot
  restart
}

main
