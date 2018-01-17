provider "google" {
  credentials = "${file("../andela-learning-da1e60624053.json")}"
  project     = "andela-learning"
  region      = "europe-west3"
}