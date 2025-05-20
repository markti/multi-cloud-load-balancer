source "azure-arm" "vm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  location                          = var.azure_primary_location
  managed_image_name                = "${var.image_name}-${var.image_version}"
  managed_image_resource_group_name = var.gallery_resource_group

  shared_image_gallery_destination {

    subscription   = var.subscription_id
    resource_group = var.gallery_resource_group
    gallery_name   = var.gallery_name
    image_name     = var.image_name
    image_version  = var.image_version

    replication_regions = [
      var.azure_primary_location
    ]
  }

  use_azure_cli_auth           = true
  communicator                 = "ssh"
  os_type                      = "Linux"
  image_publisher              = "Canonical"
  image_offer                  = "ubuntu-24_04-lts"
  image_sku                    = "ubuntu-pro"
  vm_size                      = "Standard_DS2_v2"
  allowed_inbound_ip_addresses = [var.my_ip_address]

}