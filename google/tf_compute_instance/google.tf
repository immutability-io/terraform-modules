# --- https://www.terraform.io/docs/providers/google/index.html
provider "google" {
  credentials = "${file("account.json")}"
  project     = "${var.gce-project}"
  region      = "${var.google_region}"
}
