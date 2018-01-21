provider "google" {
  credentials = "${file("../../gcp-account.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}

terraform {
  backend "gcs" {}
}