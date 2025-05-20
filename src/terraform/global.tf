resource "azurerm_resource_group" "global" {
  name     = "rg-${var.application_name}-${random_string.random_string.result}-global"
  location = var.azure_region
}

resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = "afd-${var.application_name}-${random_string.random_string.result}"
  resource_group_name = azurerm_resource_group.global.name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "main" {
  name                     = "fde-${var.application_name}-${random_string.random_string.result}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
}

resource "azurerm_cdn_frontdoor_origin_group" "multi_cloud" {
  name                     = "multi-cloud-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  session_affinity_enabled = false

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    protocol            = "Http"
    interval_in_seconds = 30
    path                = "/"
    request_type        = "GET"
  }
}

resource "azurerm_cdn_frontdoor_origin" "aws" {
  name                           = "aws-origin"
  host_name                      = module.aws_stack.public_ip_address
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.multi_cloud.id
  certificate_name_check_enabled = false
  enabled                        = true
  http_port                      = 80
  https_port                     = 443
}

resource "azurerm_cdn_frontdoor_origin" "azure" {
  name                           = "azure-origin"
  host_name                      = module.azure_stack.public_ip_address
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.multi_cloud.id
  certificate_name_check_enabled = false
  enabled                        = true
  http_port                      = 80
  https_port                     = 443
}

resource "azurerm_cdn_frontdoor_origin" "gcp" {
  name                           = "gcp-origin"
  host_name                      = module.gcp_stack.public_ip_address
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.multi_cloud.id
  certificate_name_check_enabled = false
  enabled                        = true
  http_port                      = 80
  https_port                     = 443
}

resource "azurerm_cdn_frontdoor_route" "global_route" {
  name                          = "fder-${var.application_name}-${random_string.random_string.result}"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.multi_cloud.id
  supported_protocols           = ["Http"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpOnly"
  https_redirect_enabled        = false
  cdn_frontdoor_origin_ids = [
    azurerm_cdn_frontdoor_origin.aws.id,
    azurerm_cdn_frontdoor_origin.azure.id,
    azurerm_cdn_frontdoor_origin.gcp.id
  ]
  enabled = true
}
