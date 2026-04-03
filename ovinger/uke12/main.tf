##################################################
# Providers
##################################################

# Set provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.64.0"
    }
  }
}

# Må ha subscription ID og feature block
provider "azurerm" {
  features {}
  subscription_id = "REMOVED"
}

##################################################
# FELLES INFRASTRUKTUR
##################################################

# Lag en ressurs gruppe
resource "azurerm_resource_group" "lastblansering" {
  name     = "lastblansering"
  location = "France Central"
}

# Lag et virtuelt nettverk
resource "azurerm_virtual_network" "lb_nettverk" {
  name                = "lastbalanserings-nettverk"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lastblansering.location
  resource_group_name = azurerm_resource_group.lastblansering.name
}

# Lag subnet
resource "azurerm_subnet" "lb_subnet" {
  name                 = "internal-lb-subnet"
  resource_group_name  = azurerm_resource_group.lastblansering.name
  virtual_network_name = azurerm_virtual_network.lb_nettverk.name
  address_prefixes     = ["10.0.1.0/24"]
}

##################################################
# LOAD BALANCER
##################################################

# Public IP for load balancer
resource "azurerm_public_ip" "public_ip_lb" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.lastblansering.location
  resource_group_name = azurerm_resource_group.lastblansering.name
  allocation_method   = "Static"
}

# Lage Load Balancer
resource "azurerm_lb" "load_balancer" {
  name                = "LoadBalancer"
  location            = azurerm_resource_group.lastblansering.location
  resource_group_name = azurerm_resource_group.lastblansering.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip_lb.id
  }
}

# Lage backend pool for load balancer
resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "BackEndAddressPool"
}

# Lage helseprobe for load balancer
resource "azurerm_lb_probe" "http_probe" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "http-probe"
  port            = 80
  protocol        = "Http"
  request_path    = "/"
}

# Lage regel for load balancer
resource "azurerm_lb_rule" "web_rule" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "Web-Regel"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.lb_backend_pool.id
  ]

  probe_id = azurerm_lb_probe.http_probe.id
}

##################################################
# VM1
##################################################

# Lage NIC 1
resource "azurerm_network_interface" "nic1" {
  name                = "NIC-VM1"
  location            = azurerm_resource_group.lastblansering.location
  resource_group_name = azurerm_resource_group.lastblansering.name

  ip_configuration {
    name                          = "internal-nic-vm1"
    subnet_id                     = azurerm_subnet.lb_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.11"
  }
}

# Assosier NIC1 til backend pool
resource "azurerm_network_interface_backend_address_pool_association" "nic1_backend_pool" {
  network_interface_id    = azurerm_network_interface.nic1.id
  ip_configuration_name   = "internal-nic-vm1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
}

# Lage VM1
resource "azurerm_linux_virtual_machine" "linux_01" {
  name                = "Linux-01"
  resource_group_name = azurerm_resource_group.lastblansering.name
  location            = azurerm_resource_group.lastblansering.location
  size                = "Standard_B2as_v2"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("C:\\Users\\Hauk\\.ssh\\id_ed25519.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

##################################################
# VM2
##################################################
# Lage NIC 2
resource "azurerm_network_interface" "nic2" {
  name                = "NIC-VM2"
  location            = azurerm_resource_group.lastblansering.location
  resource_group_name = azurerm_resource_group.lastblansering.name

  ip_configuration {
    name                          = "internal-nic-vm2"
    subnet_id                     = azurerm_subnet.lb_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.12"
  }
}

# Assosier NIC2 til backend pool
resource "azurerm_network_interface_backend_address_pool_association" "nic2_backend_pool" {
  network_interface_id    = azurerm_network_interface.nic2.id
  ip_configuration_name   = "internal-nic-vm2"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
}

# Lage VM2
resource "azurerm_linux_virtual_machine" "linux_02" {
  name                = "Linux-02"
  resource_group_name = azurerm_resource_group.lastblansering.name
  location            = azurerm_resource_group.lastblansering.location
  size                = "Standard_B2as_v2"
  admin_username      = "adminuser2"

  network_interface_ids = [
    azurerm_network_interface.nic2.id,
  ]

  admin_ssh_key {
    username   = "adminuser2"
    public_key = file("C:\\Users\\Hauk\\.ssh\\id_ed25519.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

##################################################
# FELLES SIKKERHET
##################################################

# NSG regler
resource "azurerm_network_security_group" "nsg_for_subnet" {
  name                = "NSG-for-subnet"
  location            = azurerm_resource_group.lastblansering.location
  resource_group_name = azurerm_resource_group.lastblansering.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Assosier NSG til subnet og NICs
resource "azurerm_network_interface_security_group_association" "nic1_nsg" {
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = azurerm_network_security_group.nsg_for_subnet.id
}

resource "azurerm_network_interface_security_group_association" "nic2_nsg" {
  network_interface_id      = azurerm_network_interface.nic2.id
  network_security_group_id = azurerm_network_security_group.nsg_for_subnet.id
}