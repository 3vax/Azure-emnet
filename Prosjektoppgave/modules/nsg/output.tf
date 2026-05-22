# output.tf (nsg)

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}

output "nsg_name" {
  value = azurerm_network_security_group.nsg.name
}

output "security_rule_names" {
  value = [
    for rule in azurerm_network_security_rule.rules : rule.name
  ]
}