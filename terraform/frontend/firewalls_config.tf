// Setup project firewalls
resource "google_compute_firewall" "firewall_frontend_allow_icmp" {
  name          = "allow-icmp-frontend"
  description   = "Allow ICMP access across the firewall into the Frontend Virtual Private Cloud."
  network       = "${google_compute_network.vpc_frontend.self_link}"
  allow {
    protocol    = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "firewall_frontend_allow_http" {
  name          = "allow-http-frontend"
  description   = "Allow HTTP access across the firewall into the Frontend Virtual Private Cloud."
  network       = "${google_compute_network.vpc_frontend.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["80", "8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "firewall_frontend_allow_https" {
  name          = "allow-https-frontend"
  description   = "Allow HTTPS access across the firewall into the Frontend Virtual Private Cloud."
  network       = "${google_compute_network.vpc_frontend.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

resource "google_compute_firewall" "firewall_frontend_allow_private-ssh" {
  name          = "allow-ssh-private-frontend"
  description   = "Allow SSH access across the firewall into the Private Subnet of the Frontend Virtual Private Cloud."
  network       = "${google_compute_network.vpc_frontend.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["22"]
  }
  source_ranges = ["${google_compute_subnetwork.subnet_public_frontend.ip_cidr_range}"]
  target_tags   = ["private"]
}

resource "google_compute_firewall" "firewall_frontend_allow_public-ssh" {
  name          = "allow-ssh-public-frontend"
  description   = "Allow SSH access across the firewall into the Public Subnet of the Frontend Virtual Private Cloud."
  network       = "${google_compute_network.vpc_frontend.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["public"]
}

resource "google_compute_firewall" "firewall_frontend_allow_all_out" {
  name               = "allow-all-out-frontend"
  description        = "Allow all outbound connections access across the firewall of the Frontend Virtual Private Cloud."
  direction          = "EGRESS"
  network            = "${google_compute_network.vpc_frontend.self_link}"
  allow {
    protocol         = "all"
  }
  destination_ranges = ["0.0.0.0/0"]
}