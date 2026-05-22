# main.tf (nettverk)

resource "azurerm_virtual_network" "vnet" {
  for_each = var.networks

  name                = "vnet-${each.key}"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  address_space       = each.value.address_space
}

# Lage subnets i hvert virtuelt nettverk
resource "azurerm_subnet" "subnet" {
  for_each = merge([
    for vnet_key, vnet in var.networks : {
      for subnet_key, subnet in vnet.subnets :
      "${vnet_key}-${subnet_key}" => {
        vnet_key            = vnet_key
        subnet_key          = subnet_key
        name                = subnet_key
        resource_group_name = vnet.resource_group_name
        address_prefixes    = subnet.address_prefixes
        delegation          = try(subnet.delegation, null)
      }
    }
  ]...)

  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet_key].name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
    for_each = each.value.delegation == null ? [] : [each.value.delegation]

    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

# Lag public IP-adresser i Azure
resource "azurerm_public_ip" "public_ip" {
  for_each = var.public_ips

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
}