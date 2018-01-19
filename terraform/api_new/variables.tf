variable "project" {}

variable "region" {}

variable "vault_auth_token" {}

variable "startup_scripts" {
  type = "map"
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "static_ips" {
  type = "map"
}

variable "build_commit" {
  default = "d8761569e171320dc88ae61c7bddafec42a50310"
}

variable "nat_image" {
  default = "ubuntu-1604-xenial-v20180109"
}

variable "subnet_cidrs" {
  type = "map"
}