// Configure external IP addresses

resource "google_compute_address" "ip_ep_api_nat" {
  name = "ip-api-nat-gateway"
  region = "${var.region}"
}

resource "google_compute_address" "ip_st_api_vault" {
  name = "vault-internal-ip"
  region = "${var.region}"
  address_type = "INTERNAL"
  subnetwork = "${google_compute_subnetwork.subnet_private_api.self_link}"
  address = "${lookup(var.static_ips, "vault")}"
}

resource "google_compute_address" "ip_st_api_redis" {
  name = "redis-internal-ip"
  region = "${var.region}"
  address_type = "INTERNAL"
  subnetwork = "${google_compute_subnetwork.subnet_private_api.self_link}"
  address = "${lookup(var.static_ips, "redis")}"
}

resource "google_compute_address" "ip_st_api_postgresql" {
  name = "postgresql-internal-ip"
  region = "${var.region}"
  address_type = "INTERNAL"
  subnetwork = "${google_compute_subnetwork.subnet_private_api.self_link}"
  address = "${lookup(var.static_ips, "postgresql")}"
}

resource "google_compute_address" "ip_st_api_backup_db" {
  name = "backup-db-internal-ip"
  region = "${var.region}"
  address_type = "INTERNAL"
  subnetwork = "${google_compute_subnetwork.subnet_private_api.self_link}"
  address = "${lookup(var.static_ips, "backup_db")}"
}