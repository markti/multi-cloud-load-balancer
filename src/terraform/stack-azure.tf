
data "azurerm_shared_image_version" "main" {
  name                = var.image_version
  image_name          = var.image_name
  gallery_name        = "galqonqgallerydev"
  resource_group_name = "rg-qonq-gallery-dev"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.application_name}-${random_string.random_string.result}"
  location = var.azure_region
}

module "azure_stack" {
  source = "./modules/stack/azure"

  name                = "${var.application_name}-${random_string.random_string.result}"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = "10.5.16.0/22"
  vm_image_id         = data.azurerm_shared_image_version.main.id
  vm_size             = "Standard_DS1_v2"
  ssh_public_key      = tls_private_key.ssh_key.public_key_openssh
  ssh_private_key     = tls_private_key.ssh_key.private_key_pem
  username            = var.username

}
