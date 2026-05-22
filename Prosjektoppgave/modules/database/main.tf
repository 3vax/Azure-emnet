# main.tf (database)

resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_password

  public_network_access_enabled = var.public_network_access_enabled
}

resource "azurerm_mssql_database" "sql_database" {
  name      = var.database_name
  server_id = azurerm_mssql_server.sql_server.id

  sku_name    = var.sku_name
  max_size_gb = var.max_size_gb

  min_capacity                = var.min_capacity
  auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
