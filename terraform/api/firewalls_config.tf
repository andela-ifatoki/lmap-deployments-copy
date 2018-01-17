// Setup project firewalls

resource "google_compute_firewall" "firewall_api_allow_icmp" {
  name          = "allow-icmp-api"
  description   = "Allow ICMP access across the firewall into the API Virtual Private Cloud."
  network       = "${google_compute_network.vpc_api.self_link}"
  allow {
    protocol    = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "firewall_api_allow_http" {
  name          = "allow-http-api"
  description   = "Allow HTTP access across the firewall into the API Virtual Private Cloud."
  network       = "${google_compute_network.vpc_api.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["80", "8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "firewall_api_allow_https" {
  name          = "allow-https-api"
  description   = "Allow HTTPS access across the firewall into the api Virtual Private Cloud."
  network       = "${google_compute_network.vpc_api.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

resource "google_compute_firewall" "firewall_api_allow_private-ssh" {
  name          = "allow-ssh-private-api"
  description   = "Allow SSH access across the firewall into the Private Subnet of the API Virtual Private Cloud."
  network       = "${google_compute_network.vpc_api.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["22"]
  }
  source_ranges = ["${google_compute_subnetwork.subnet_public_api.ip_cidr_range}"]
  target_tags   = ["private"]
}

resource "google_compute_firewall" "firewall_api_allow_public-ssh" {
  name          = "allow-ssh-public-api"
  description   = "Allow SSH access across the firewall into the Public Subnet of the API Virtual Private Cloud."
  network       = "${google_compute_network.vpc_api.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["public"]
}

resource "google_compute_firewall" "firewall_api_allow_postgresql" {
  name          = "allow-postgresql"
  description   = "Allow connections to postgresql access across the firewall."
  network       = "${google_compute_network.vpc_api.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["5432"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["postgresql-server"]
}

resource "google_compute_firewall" "firewall_api_allow_redis" {
  name          = "allow-redis"
  description   = "Allow connections to the redis server access across the firewall."
  network       = "${google_compute_network.vpc_api.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["6379"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["redis-server"]
}

resource "google_compute_firewall" "firewall_api_allow_vault" {
  name          = "allow-vault"
  description   = "Allow connections to the vault server access across the firewall."
  network       = "${google_compute_network.vpc_api.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["8200"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["vault-server"]
}

resource "google_compute_firewall" "firewall_api_allow_all_out" {
  name               = "allow-all-out-api"
  description        = "Allow all outbound connections access across the firewall of the API Virtual Private Cloud."
  direction          = "EGRESS"
  network            = "${google_compute_network.vpc_api.self_link}"
  allow {
    protocol         = "all"
  }
  destination_ranges = ["0.0.0.0/0"]
}