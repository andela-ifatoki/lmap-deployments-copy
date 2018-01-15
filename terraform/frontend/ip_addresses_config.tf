// Configure external IP addresses
resource "google_compute_address" "ip_ep_frontend_nat" {
  name = "ip-frontend-nat-gateway"
  region = "europe-west3"
}