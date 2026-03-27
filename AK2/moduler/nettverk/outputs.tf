# outputs.tf (nettverk)
output "net_id" {
	description = "Network ID"
	value = azurerm_virtual_network.vnet.id	
}

output "subnet_ids" {
  description = "Subnet IDs med navn som nøkkel"
  value = {
    for subnet in azurerm_subnet.vnet_subnet :
    subnet.name => subnet.id
  }
}

output "public_ip_id" {
    description = "Public IP ID"
    value = azurerm_public_ip.public_ip.id
}

