provider "google" {
  region = "europe-west3"
	project = "learning-map-app"
  credentials = "${file("path_to_gcloud_credentials_file")}"
}

resource "google_compute_instance_template" "instance_template" {
  name = "instance-template-lmap-frontend"
  machine_type = "n1-standard-1"
	tags = ["private", "http-server", "https-server"]
	metadata_startup_script = "sudo su - andeladeveloper -c \"git clone git@github.com:andela/learning-map-front.git; cd learning-map-front; sudo yarn install; nohup sudo yarn build &\" "
	instance_description = "Learning map frontend instance"
	disk {
   		 source_image = "lmap-frontend-packer-image"
    		 auto_delete  = false
    		 boot         = true
  }

	network_interface {
		subnetwork = "${google_compute_subnetwork.subnet_private_frontend.self_link}"
}
	lifecycle {
		create_before_destroy = true
	}
}

resource "google_compute_autoscaler" "lmap_front_autoscaler" {
  name   = "lmap-front-autoscaler"
  zone = "europe-west3-b"
  target = "${google_compute_instance_group_manager.instance_group.self_link}"

  autoscaling_policy = {
    max_replicas    = 3
    min_replicas    = 2
    cooldown_period = 180
    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_instance_group_manager" "instance_group" {
	name = "instance-group-lmap-frontend"
	instance_template = "${google_compute_instance_template.instance_template.self_link}"
	base_instance_name = "instance-group-lmap-frontend"
	zone = "europe-west3-b"
	named_port {
    name = "http"
    port = 3000
}
}

module "gce_lb_http" {
	source = "GoogleCloudPlatform/lb-http/google"
	name = "load-balancer-lmap-frontend"
	target_tags = ["public", "http-server", "https-server"]
	ssl = true
	backends = {
		"0" = [
			{ group = "${google_compute_instance_group_manager.instance_group.instance_group}" }
],
}

backend_params = [
	"/healthcheck,http,3000,15"
]
	private_key = "${file("path_to_.key_file")}"
	certificate = "${file("path_to_.crt_file")}"
}