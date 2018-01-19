project = "learning-map-app"
region = "europe-west3"
vault_auth_token = "5c3cd317-fc42-1aba-0886-04c99627dba2"
startup_scripts = {
  nat = "sudo sysctl -w net.ipv4.ip_forward=1; sudo iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE"
  postgresql = "sudo su - postgres -c '. /home/packer/postgres-startup.sh'"
  backup_db = "sudo su - barman -c '. /home/packer/barman-startup.sh'"
  api = "sudo su - ubuntu -c '. /home/packer/apiserver-startup.sh'"
  vault = "vault server -config=\"/home/packer/vault_config_file.hcl\""
  redis = "systemctl restart redis-server.service"
}
subnet_cidrs = {
  private = "10.0.0.0/27"
  public = "10.0.0.32/29"
}
static_ips = {
  vault = "10.0.0.3"
  redis = "10.0.0.4"
  postgresql = "10.0.0.5"
  backup_db = "10.0.0.7"
}
