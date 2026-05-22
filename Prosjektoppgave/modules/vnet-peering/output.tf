# output.tf (vnet-peering)

output "vnet_peerings" {
  description = "VNet-peerings som er opprettet"
  value       = azurerm_virtual_network_peering.peering
}
