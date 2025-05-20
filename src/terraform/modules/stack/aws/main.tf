data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_shuffle" "az" {
  input        = data.aws_availability_zones.available.names
  result_count = 1
}

module "network" {
  source = "../../network/aws"

  name              = var.name
  address_space     = var.address_space
  availability_zone = random_shuffle.az.result[0]
  tags              = var.tags

}

module "vm" {
  source = "../../vm/aws"

  name              = var.name
  subnet_id         = module.network.subnet_id
  vm_image_id       = var.vm_image_id
  vm_size           = var.vm_size
  ssh_public_key    = var.ssh_public_key
  ssh_private_key   = var.ssh_private_key
  security_group_id = module.network.security_group_id
  tags              = var.tags
  username          = var.username

}
