# output.tf (loadbalancer)

output "loadbalancer_id" {
  value = azurerm_lb.lb.id
}

output "loadbalancer_name" {
  value = azurerm_lb.lb.name
}

output "frontend_ip_configuration_name" {
  value = azurerm_lb.lb.frontend_ip_configuration[0].name
}

output "backend_address_pool_id" {
  value = azurerm_lb_backend_address_pool.backend_pool.id
}

output "backend_address_pool_name" {
  value = azurerm_lb_backend_address_pool.backend_pool.name
}

output "probe_ids" {
  value = {
    for key, probe in azurerm_lb_probe.probes : key => probe.id
  }
}

output "rule_ids" {
  value = {
    for key, rule in azurerm_lb_rule.rules : key => rule.id
  }
}