
data "google_billing_account" "main" {
  display_name    = "Default"
  lookup_projects = false
}

resource "google_project" "main" {
  name            = "${var.application_name}-${random_string.random_string.result}"
  project_id      = "${var.application_name}-${random_string.random_string.result}"
  org_id          = var.gcp_organization
  billing_account = data.google_billing_account.main.id
}

resource "google_project_service" "compute" {

  project = google_project.main.project_id
  service = "compute.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

data "google_compute_image" "main" {
  project = "packer-images-402019"
  name    = "${var.image_name}-${replace(var.image_version, ".", "-")}"
}
# "e2-micro"

module "gcp_stack" {
  source = "./modules/stack/gcp"

  project_id      = google_project.main.project_id
  region          = var.gcp_region
  name            = "${var.application_name}-${random_string.random_string.result}"
  address_space   = "10.5.16.0/22"
  vm_image_id     = data.google_compute_image.main.id
  vm_size         = "e2-micro"
  ssh_public_key  = tls_private_key.ssh_key.public_key_openssh
  ssh_private_key = tls_private_key.ssh_key.private_key_pem
  username        = var.username

  depends_on = [google_project_service.compute]

}
