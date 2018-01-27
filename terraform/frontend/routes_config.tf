// Configure private subnet network routing through nat gateway
resource "google_compute_route" "private_subnet_frontend" {
  name        = "private-subnet-frontend-internet-access"
  dest_range  = "0.0.0.0/0"
  network     = "${google_compute_network.vpc_frontend.self_link}"
  next_hop_instance = "${google_compute_instance.nat_frontend_gateway.self_link}"
  priority    = 1000
  tags = ["private"]
}