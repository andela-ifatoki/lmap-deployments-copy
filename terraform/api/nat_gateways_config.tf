// Configure NAT gateways.
resource "google_compute_instance" "nat_api_gateway" {
  name         = "nat-api-instance"
  description  = "A NAT instance to help provide internet access to the API instances in the private subnet."
  machine_type = "${var.machine_type}"
  zone         = "europe-west3-a"
  metadata_startup_script = "${lookup(var.startup_scripts, "nat")}"
  boot_disk {
    initialize_params {
      image = "${var.nat_image}"
    }
  }
  network_interface {
    subnetwork  = "${google_compute_subnetwork.subnet_public_api.self_link}"
    access_config {
      nat_ip = "${google_compute_address.ip_ep_api_nat.address}"
    }
  }
  can_ip_forward = "true"
  tags = ["nat", "public", "http-server", "https-server"]
  service_account {
    scopes = ["cloud-platform"]
  }
}
