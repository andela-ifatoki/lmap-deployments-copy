// Configure frontend subnets
resource "google_compute_subnetwork" "subnet_private_frontend" {
  name          = "subnet-private-lmap-frontend"
  description   = "Private subnet for the Learning map Frontend project"
  ip_cidr_range = "10.0.0.0/27"
  network       = "${google_compute_network.vpc_frontend.self_link}"
}

resource "google_compute_subnetwork" "subnet_public_frontend" {
  name          = "subnet-public-lmap-frontend"
  description   = "Public subnet for the Learning map Frontend project"
  ip_cidr_range = "10.0.0.32/29"
  network       = "${google_compute_network.vpc_frontend.self_link}"
}