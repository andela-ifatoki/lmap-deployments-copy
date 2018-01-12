// Configure the Google Cloud provider
provider "google" {
  credentials = "andela-learning-da1e60624053.json"
  project     = "andela-learning"
  region      = "europe-west3"
}

// Configure test instance
resource "google_compute_instance" "test_instance" {
  name         = "instance-1"
  description  = "An instance to test the functionality of NAT."
  machine_type = "n1-standard-1"
  zone         = "europe-west3-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20180109"
    }
  }
  network_interface {
    subnetwork  = "${google_compute_subnetwork.subnet_private_api.self_link}"
    address = ""
  }
  tags = ["http-server", "https-server", "private"]
  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "test_instance-1" {
  name         = "instance-2"
  description  = "An instance to test the functionality of NAT."
  machine_type = "n1-standard-1"
  zone         = "europe-west3-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20180109"
    }
  }
  network_interface {
    subnetwork  = "${google_compute_subnetwork.subnet_private_frontend.self_link}"
    address = ""
  }
  tags = ["http-server", "https-server", "private"]
  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "lmap_vault" {
  name         = "vault"
  description  = "An vault instance to help with secrets management."
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