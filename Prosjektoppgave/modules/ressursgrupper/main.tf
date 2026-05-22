# main.tf (ressursgrupper)

resource "azurerm_resource_group" "rg" {
  for_each = var.ressursgrupper

  name     = each.value
  location = var.location
}