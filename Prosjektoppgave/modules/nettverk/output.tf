# output.tf (nettverk)

output "vnets" {
  value = {
    for key, vnet in azurerm_virtual_network.vnet : key => {
      name                = vnet.name
      id                  = vnet.id
      resource_group_name = vnet.resource_group_name
      location            = vnet.location
    }
  }
}

output "subnets" {
  value = {
    for key, subnet in azurerm_subnet.subnet : key => {
      name             = subnet.name
      id               = subnet.id
      address_prefixes = subnet.address_prefixes
    }
  }
}

output "public_ips" {
  value = {
    for key, pip in azurerm_public_ip.public_ip : key => {
      name       = pip.name
      id         = pip.id
      ip_address = pip.ip_address
    }
  }
}