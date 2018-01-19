// Setup Instance groups and its dependencies

resource "google_compute_region_instance_group_manager" "lmap_api_instance_group_manager" {
  name               = "lmap-api-instance-group"
  base_instance_name = "lmap-api-instance-group"
  region = "${var.region}"
  instance_template  = "${google_compute_instance_template.lmap_api_instance_template.self_link}"
  named_port {
    name = "http"
    port = 8080
  }
  auto_healing_policies {
    health_check      = ""
    initial_delay_sec = 300
  }
}

resource "google_compute_region_autoscaler" "lmap_api_autoscaler" {
  name   = "lmap-api-autoscaler"
  region = "${var.region}"
  target = "${google_compute_region_instance_group_manager.lmap_api_instance_group_manager.self_link}"

  autoscaling_policy = {
    max_replicas    = 3
    min_replicas    = 2
    cooldown_period = 180
    cpu_utilization {
      target = 0.6
    }
  }
}
