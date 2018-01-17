provider "google" {
  credentials = "${file("../andela-learning-da1e60624053.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}