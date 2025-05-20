
module "network" {
  source = "../../network/azure"

  name                = var.name
  location            = var.location
  address_space       = var.address_space
  resource_group_name = var.resource_group_name

}

module "vm" {
  source = "../../vm/azure"

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.network.subnet_id
  vm_image_id         = var.vm_image_id
  vm_size             = var.vm_size
  ssh_public_key      = var.ssh_public_key
  ssh_private_key     = var.ssh_private_key
  username            = var.username

}
