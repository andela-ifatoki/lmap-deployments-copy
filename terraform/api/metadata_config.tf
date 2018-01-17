// Setup all project-wide metadata.

resource "google_compute_project_metadata" "lmap_api_project_metadata" {
  metadata {
    vault_auth_token  = "0372bb0c-9ceb-6f33-6bbc-ffeb7765621d"
    build_commit = "d8761569e171320dc88ae61c7bddafec42a50310"
    learning_map_env = "REDIS_URL=redis://10.0.0.4\nFLASK_CONFIG=development\nFLASK_APP=main.py\nDB_TYPE=postgresql"
  }
}