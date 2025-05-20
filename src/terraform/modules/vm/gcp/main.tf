resource "google_compute_address" "main" {
  project = var.project_id
  name    = "${var.name}-public-ip"
  region  = var.region
}

resource "google_compute_instance" "vm" {
  project      = var.project_id
  name         = "vm-${var.name}"
  machine_type = var.vm_size
  zone         = var.availability_zone

  boot_disk {
    initialize_params {
      image = var.vm_image_id
    }
  }

  network_interface {
    subnetwork = var.subnet_id
    access_config {
      nat_ip = google_compute_address.main.address
    }
  }

  metadata = {
    ssh-keys = "${var.username}:${var.ssh_public_key}"
  }
}
