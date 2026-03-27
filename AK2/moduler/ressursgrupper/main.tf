# main.tf (ressursgrupper)
# Lag ressurs gruppe i Azure
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}