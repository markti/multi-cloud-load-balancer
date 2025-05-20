resource "google_compute_network" "main" {
  project                 = var.project_id
  name                    = var.name
  auto_create_subnetworks = false
}

locals {
  # get the last /24
  subnet_prefix = cidrsubnet(var.address_space, 2, 3)
}

resource "google_compute_subnetwork" "main" {

  project       = var.project_id
  name          = var.name
  region        = var.region
  network       = google_compute_network.main.self_link
  ip_cidr_range = local.subnet_prefix

}

resource "google_compute_firewall" "allow_http_https_ssh" {

  project = var.project_id
  name    = "allow-web"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}
