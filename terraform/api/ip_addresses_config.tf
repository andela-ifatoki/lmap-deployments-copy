// Configure external IP addresses

resource "google_compute_address" "ip_ep_api_nat" {
  name = "ip-api-nat-gateway"
  region = "europe-west3"
}

resource "google_compute_address" "ip_st_api_vault" {
  name = "vault-internal-ip"
  region = "europe-west3"
  address_type = "INTERNAL"
  subnetwork = "${google_compute_subnetwork.subnet_private_api.self_link}"
  address = "10.0.0.3"
}

resource "google_compute_address" "ip_st_api_redis" {
  name = "redis-internal-ip"
  region = "europe-west3"
  address_type = "INTERNAL"
  subnetwork = "${google_compute_subnetwork.subnet_private_api.self_link}"
  address = "10.0.0.4"
}

resource "google_compute_address" "ip_st_api_postgresql" {
  name = "postgresql-internal-ip"
  region = "europe-west3"
  address_type = "INTERNAL"
  subnetwork = "${google_compute_subnetwork.subnet_private_api.self_link}"
  address = "10.0.0.5"
}