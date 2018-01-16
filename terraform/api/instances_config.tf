// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("../andela-learning-da1e60624053.json")}"
  project     = "andela-learning"
  region      = "europe-west3"
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

resource "google_compute_region_instance_group_manager" "lmap_api_instance_group_manager" {
  name               = "lmap-api-instance-group-manager"
  base_instance_name = "lmap-api-instance-group"
  region = "europe-west3"
  instance_template  = "${google_compute_instance_template.lmap_api_instance_template.self_link}"
  named_port {
    name = "http"
    port = 8080
  }
  auto_healing_policies {
    health_check      = ""
    initial_delay_sec = 300
  }
}

resource "google_compute_region_autoscaler" "lmap_api_autoscaler" {
  name   = "lmap-api-autoscaler"
  region = "europe-west3"
  target = "${google_compute_region_instance_group_manager.lmap_api_instance_group_manager.self_link}"

  autoscaling_policy = {
    max_replicas    = 3
    min_replicas    = 2
    cooldown_period = 180
    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_project_metadata" "lmap_api_project_metadata" {
  metadata {
    vault_auth_token  = "de24f3ce-f3fb-79bb-a7ea-d20fe8eae9f6"
    build_commit = "d8761569e171320dc88ae61c7bddafec42a50310"
    learning_map_env = "REDIS_URL=redis://10.0.0.4\nFLASK_CONFIG=development\nFLASK_APP=main.py\nDB_TYPE=postgresql"
  }
}
