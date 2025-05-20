
data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
}

resource "random_shuffle" "az" {
  input        = data.google_compute_zones.available.names
  result_count = 1
}

module "network" {
  source = "../../network/gcp"

  project_id        = var.project_id
  region            = var.region
  name              = var.name
  address_space     = var.address_space
  availability_zone = random_shuffle.az.result[0]

}

module "vm" {
  source = "../../vm/gcp"

  project_id        = var.project_id
  region            = var.region
  availability_zone = random_shuffle.az.result[0]
  name              = var.name
  subnet_id         = module.network.subnet_id
  vm_image_id       = var.vm_image_id
  vm_size           = var.vm_size
  ssh_public_key    = var.ssh_public_key
  ssh_private_key   = var.ssh_private_key
  security_group_id = module.network.security_group_id
  username          = var.username

}
