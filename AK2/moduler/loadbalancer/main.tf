# main.tf (loadbalancer)
# Lage load balancer i Azure
resource "azurerm_lb" "lb" {
    name                     = var.lb_name
    location                 = var.location
    resource_group_name      = var.rg_name
    frontend_ip_configuration {
        name                 = var.lb_frontend_name
        public_ip_address_id = var.public_ip_id
    }
}

# Lage backend pool for load balancer
resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
    count           = length(var.lb_backend_pool_names)
    name            = var.lb_backend_pool_names[count.index]
    loadbalancer_id = azurerm_lb.lb.id
}

# Lage health probe for load balancer
resource "azurerm_lb_probe" "http_probe_01" {
    name            = var.http_probe_name
    loadbalancer_id = azurerm_lb.lb.id
    protocol        = "Http"
    port            = 80
    request_path    = "/"
}

# Lage regler til load balancer
resource "azurerm_lb_rule" "http_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "WebRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.lb_frontend_name
  backend_address_pool_ids       = azurerm_lb_backend_address_pool.lb_backend_pool[*].id
  probe_id                       = azurerm_lb_probe.http_probe_01.id
}

resource "azurerm_lb_nat_pool" "ssh_nat_pool" {
  resource_group_name            = var.rg_name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "ssh-nat-pool"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = var.lb_frontend_name
}