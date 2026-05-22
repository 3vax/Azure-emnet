# output.tf (filserver)

output "storage_account_name" {
  value = azurerm_storage_account.filserver.name
}

output "storage_account_id" {
  value = azurerm_storage_account.filserver.id
}

output "primary_access_key" {
  value     = azurerm_storage_account.filserver.primary_access_key
  sensitive = true
}

output "share_names" {
  value = {
    for key, share in azurerm_storage_share.shares : key => share.name
  }
}