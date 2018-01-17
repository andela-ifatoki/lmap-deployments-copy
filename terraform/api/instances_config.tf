// Configure the Google Cloud provider Instances and instance groups

resource "google_compute_instance_template" "lmap_api_instance_template" {
  name = "lmap-api-instance-template"
  description = "This template is used to create app server instances."
  instance_description = "A Learning Map API Server instance."
  machine_type = "n1-standard-1"
  metadata_startup_script = "sudo su - ubuntu -c '. /home/packer/apiserver-startup.sh'"
  disk {
    boot = "true"
    source_image = "lmap-api-base-image"
  }
  network_interface {
    subnetwork  = "${google_compute_subnetwork.subnet_private_api.self_link}"
  }
  tags = ["http-server", "https-server", "private"]
  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "lmap_vault" {
  name         = "lmap-vault-server"
  description  = "A vault instance to help with secrets management."
  machine_type = "n1-standard-1"
  zone         = "europe-west3-a"
  metadata_startup_script = "vault server -config=\"/home/packer/vault_config_file.hcl\""
  boot_disk {
    initialize_params {
      image = "lmap-vault-base-image"
    }
  }
  network_interface {
    subnetwork  = "${google_compute_subnetwork.subnet_private_api.self_link}"
    address = "${google_compute_address.ip_st_api_vault.address}"
  }
  tags = ["vault-server", "private"]
  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "lmap_redis" {
  name         = "lmap-redis-server"
  description  = "A redis server."
  machine_type = "n1-standard-1"
  zone         = "europe-west3-a"
  metadata_startup_script = "systemctl restart redis-server.service"
  boot_disk {
    initialize_params {
      image = "lmap-redis-base-image"
    }
  }
  network_interface {
    subnetwork  = "${google_compute_subnetwork.subnet_private_api.self_link}"
    address = "${google_compute_address.ip_st_api_redis.address}"
  }
  tags = ["redis-server", "private"]
  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "lmap_postgresql" {
  name         = "lmap-postgresql-server"
  description  = "A postgresql server."
  machine_type = "n1-standard-1"
  zone         = "europe-west3-a"
  metadata_startup_script = "service postgresql start"
  boot_disk {
    initialize_params {
      image = "lmap-postgresdb-base-image"
    }
  }
  network_interface {
    subnetwork  = "${google_compute_subnetwork.subnet_private_api.self_link}"
    address = "${google_compute_address.ip_st_api_postgresql.address}"
  }
  tags = ["postgresql-server", "private"]
  service_account {
    scopes = ["cloud-platform"]
  }
}
