// Setup all project-wide metadata.

resource "google_compute_project_metadata" "lmap_api_project_metadata" {
  metadata {
    vault_auth_token  = "${file("./vault_auth_token")}"
    build_commit = "${var.build_commit}"
    learning_map_env = "REDIS_URL=redis://${lookup(var.static_ips, "redis")}\nFLASK_CONFIG=development\nFLASK_APP=main.py\nDB_TYPE=postgresql"
  }
}