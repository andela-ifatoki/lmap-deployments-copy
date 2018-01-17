module "gce_lb_http" {
  source = "GoogleCloudPlatform/lb-http/google"
  name = "lmap-api-loadbalancer"
  target_tags = ["http-server", "https-server"]
  network = "${google_compute_network.vpc_api.name}"
  backends = {
    "0" = [
      { group = "${google_compute_region_instance_group_manager.lmap_api_instance_group_manager.instance_group}" }
    ],
  }
  backend_params = [
    "/,http,8080,10"
  ]
}