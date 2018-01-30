// Configure VPC
resource "google_compute_network" "vpc_frontend" {
  name                    = "vpc-lmap-frontend"
  description             = "Virtual Private Cloud for the Learning Map Frontend project"
  auto_create_subnetworks = "false"
}