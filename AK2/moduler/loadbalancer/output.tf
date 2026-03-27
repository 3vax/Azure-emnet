output "backend_address_pool_ids" {
  value = {
    for pool in azurerm_lb_backend_address_pool.lb_backend_pool :
    pool.name => pool.id
  }
}