# output.tf (scale-set)

output "vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.id
}

output "vmss_name" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.name
}

output "vmss_resource_group_name" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.resource_group_name
}

output "vmss_location" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.location
}