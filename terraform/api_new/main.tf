provider "google" {
  credentials = "${file("../learning-map-55757f86b1bc.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}