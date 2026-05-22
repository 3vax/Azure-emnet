# main.tf(loadbalancer)

# Lage loadbalancer i Azure
resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = var.public_ip_address_id
  }
}

# Lage backend pool for loadbalancer
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = var.backend_address_pool_name
}

# Lage helse prober for lastbalanserer
resource "azurerm_lb_probe" "probes" {
  for_each = var.probes

  name            = each.key
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = each.value.protocol
  port            = each.value.port
  request_path    = each.value.protocol == "Http" || each.value.protocol == "Https" ? each.value.request_path : null
}

# Lage regler for lastbalansereren
resource "azurerm_lb_rule" "rules" {
  for_each = var.rules

  loadbalancer_id                = azurerm_lb.lb.id
  name                           = each.key
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.probes[each.value.probe_key].id
}
