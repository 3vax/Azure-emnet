# main.tf (filserver)

# Opprett en Azure Storage Account som skal brukes som filserver
resource "azurerm_storage_account" "filserver" {
  name                          = var.storage_account_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = var.account_tier
  account_replication_type      = var.account_replication_type

  min_tls_version               = "TLS1_2"
  public_network_access_enabled = var.public_network_access_enabled
}

# Opprett Azure File Shares i storage accounten
resource "azurerm_storage_share" "shares" {
  for_each = var.shares

  name                 = each.key
  storage_account_id = azurerm_storage_account.filserver.id
  quota                = each.value.quota
}