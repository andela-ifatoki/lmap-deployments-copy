// Configure NAT gateway
resource "google_compute_instance" "nat_frontend_gateway" {
  name         = "nat-frontend-instance"
  description  = "A NAT instance to help provide internet access to the frontend instances in the private subnet."
  machine_type = "n1-standard-1"
  zone         = "europe-west3-c"
  metadata_startup_script = "sudo sysctl -w net.ipv4.ip_forward=1; sudo iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE"
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20180109"
    }
  }
  network_interface {
    subnetwork  = "${google_compute_subnetwork.subnet_public_frontend.self_link}"
    access_config {
      nat_ip = "${google_compute_address.ip_ep_frontend_nat.address}"
    }
  }
  can_ip_forward = "true"
  tags = ["nat", "public", "http-server", "https-server"]
  service_account {
    scopes = ["cloud-platform"]
  }
}