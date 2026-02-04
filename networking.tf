# vnet and subnet for internal communication

removed {
  from = azurerm_subnet.subnet-endpoints
  lifecycle {
    destroy = false
  }
}

removed {
  from = azurerm_subnet.subnet-appservices
  lifecycle {
    destroy = false
  }
}

# Network Security Group for endpoints subnet
resource "azurerm_network_security_group" "nsg-endpoints" {
  name                = var.nsg_endpoints_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Network Security Group for app services subnet
resource "azurerm_network_security_group" "nsg-appservices" {
  name                = var.nsg_appservices_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_virtual_network" "vnet-scepman" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.vnet_address_space

  subnet {
    name                            = var.subnet_appservices_name
    address_prefixes                = [cidrsubnet(var.vnet_address_space[0], 3, 0)]
    default_outbound_access_enabled = false
    security_group                  = azurerm_network_security_group.nsg-appservices.id
    delegation {
      name = "delegation"
      service_delegation {
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        name    = "Microsoft.Web/serverFarms"
      }
    }
  }

  subnet {
    name                            = var.subnet_endpoints_name
    address_prefixes                = [cidrsubnet(var.vnet_address_space[0], 3, 1)]
    default_outbound_access_enabled = false
    security_group                  = azurerm_network_security_group.nsg-endpoints.id
  }
}

data "azurerm_subnet" "vnet-subnets" {
  for_each             = toset(azurerm_virtual_network.vnet-scepman.subnet.*.name)
  name                 = each.value
  virtual_network_name = azurerm_virtual_network.vnet-scepman.name
  resource_group_name  = azurerm_virtual_network.vnet-scepman.resource_group_name

  depends_on = [
    azurerm_virtual_network.vnet-scepman
  ]
}

resource "azurerm_private_dns_zone" "dnsprivatezone-kv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnszonelink-kv" {
  name                  = "dnszonelink-kv"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dnsprivatezone-kv.name
  virtual_network_id    = azurerm_virtual_network.vnet-scepman.id
}

resource "azurerm_private_dns_zone" "dnsprivatezone-sts" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnszonelink-sts" {
  name                  = "dnszonelink-sts"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dnsprivatezone-sts.name
  virtual_network_id    = azurerm_virtual_network.vnet-scepman.id
}


# Private Endpoint for Storage Account
resource "azurerm_private_endpoint" "storage_pe" {
  name                = "pep-sts-scepman"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = "${azurerm_virtual_network.vnet-scepman.id}/subnets/${var.subnet_endpoints_name}"

  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsprivatezone-sts.id]
  }

  private_service_connection {
    name                           = "storageconnection"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }
}


# Private Endpoint for Key Vault
resource "azurerm_private_endpoint" "key_vault_pe" {
  name                = "pep-kv-scepman"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = "${azurerm_virtual_network.vnet-scepman.id}/subnets/${var.subnet_endpoints_name}"

  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsprivatezone-kv.id]
  }

  private_service_connection {
    name                           = "keyvaultconnection"
    private_connection_resource_id = azurerm_key_vault.vault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}
