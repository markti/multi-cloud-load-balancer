source "googlecompute" "vm" {
  project_id   = var.gcp_project_id
  source_image = "ubuntu-2404-noble-amd64-v20250502a"
  ssh_username = "packer"
  zone         = var.gcp_primary_region
  image_name   = "${var.image_name}-${replace(var.image_version, ".", "-")}"
}