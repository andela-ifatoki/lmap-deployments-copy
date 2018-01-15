// Configure project subnets
resource "google_compute_subnetwork" "subnet_private_api" {
  name          = "subnet-private-lmap-api"
  description   = "Private subnet for the Learning map API project"
  ip_cidr_range = "10.0.0.0/27"
  network       = "${google_compute_network.vpc_api.self_link}"
}

resource "google_compute_subnetwork" "subnet_public_api" {
  name          = "subnet-public-lmap-api"
  description   = "Public subnet for the Learning map API project"
  ip_cidr_range = "10.0.0.32/29"
  network       = "${google_compute_network.vpc_api.self_link}"
}
