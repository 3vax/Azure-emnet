# output.tf (private-endpoint)

output "private_endpoint_id" {
  value = azurerm_private_endpoint.private_endpoints.id
}

output "private_endpoint_name" {
  value = azurerm_private_endpoint.private_endpoints.name
}