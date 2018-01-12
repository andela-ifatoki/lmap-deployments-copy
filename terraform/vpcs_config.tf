// Configure project networks
resource "google_compute_network" "vpc_api" {
  name                    = "vpc-lmap-api"
  description             = "Virtual Private Cloud for the Learning Map API project"
  auto_create_subnetworks = "false"  
}

resource "google_compute_network" "vpc_frontend" {
  name                    = "vpc-lmap-frontend"
  description             = "Virtual Private Cloud for the Learning Map Frontend project"
  auto_create_subnetworks = "false"
}