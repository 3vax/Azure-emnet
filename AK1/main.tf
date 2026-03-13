# Set provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.62.1"
    }
  }
}
# Må ha subscription ID og feature block
provider "azurerm" {
  features {}
  subscription_id = "den var her"
}

# Lag en ressurs gruppe
resource "azurerm_resource_group" "ak1_ressurs_gruppe" {
  name     = "ak1_ressurs_gruppe"
  location = "France Central"
}

# Lage et virtuelt nettverk og to subnett, en for hver VM, og en public IP for VM1
# Lag et virtuelt nettverk
resource "azurerm_virtual_network" "ak1_nettverk" {
  name                = "AK1-nettverk"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ak1_ressurs_gruppe.location
  resource_group_name = azurerm_resource_group.ak1_ressurs_gruppe.name
}

# Lag subnet 1
resource "azurerm_subnet" "ak1_subnet1" {
  name                 = "internal-subnet1"
  resource_group_name  = azurerm_resource_group.ak1_ressurs_gruppe.name
  virtual_network_name = azurerm_virtual_network.ak1_nettverk.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Lag subnet 2
resource "azurerm_subnet" "ak1_subnet2" {
  name                 = "internal-subnet2"
  resource_group_name  = azurerm_resource_group.ak1_ressurs_gruppe.name
  virtual_network_name = azurerm_virtual_network.ak1_nettverk.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Sette opp public IP for NIC1
resource "azurerm_public_ip" "ak1_public_ip" {
  name                = "Public-IP-for-subnet1"
  resource_group_name = azurerm_resource_group.ak1_ressurs_gruppe.name
  location            = azurerm_resource_group.ak1_ressurs_gruppe.location
  allocation_method   = "Static"
  ip_version          = "IPv4"
}

# Lage nettverks grensesnitt for VM1 og VM2
# Lage NIC 1
resource "azurerm_network_interface" "nic_subnet1" {
  name                = "NIC-sub1"
  location            = azurerm_resource_group.ak1_ressurs_gruppe.location
  resource_group_name = azurerm_resource_group.ak1_ressurs_gruppe.name

  ip_configuration {
    name                          = "internal-nic-subnet1"
    subnet_id                     = azurerm_subnet.ak1_subnet1.id
    private_ip_address_allocation = "Dynamic"
    # Referer til public ip adressen
    public_ip_address_id          = azurerm_public_ip.ak1_public_ip.id
  }
}

# Lage NIC 2
resource "azurerm_network_interface" "nic_subnet2" {
  name                = "NIC-sub2"
  location            = azurerm_resource_group.ak1_ressurs_gruppe.location
  resource_group_name = azurerm_resource_group.ak1_ressurs_gruppe.name

  ip_configuration {
    name                          = "internal-nic-subnet2"
    subnet_id                     = azurerm_subnet.ak1_subnet2.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.4"
  }
}

# Sette opp VM1 og tilhørende NSG regler.
# Lage VM1
resource "azurerm_linux_virtual_machine" "linux_01_subnet1" {
  name                = "Linux-01"
  resource_group_name = azurerm_resource_group.ak1_ressurs_gruppe.name
  location            = azurerm_resource_group.ak1_ressurs_gruppe.location
  size                = "Standard_B2as_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic_subnet1.id,
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

# NSG regler for subnet1
resource "azurerm_network_security_group" "nsg_for_subnet1" {
  name                = "NSG-for-subnet1"
  location            = azurerm_resource_group.ak1_ressurs_gruppe.location
  resource_group_name = azurerm_resource_group.ak1_ressurs_gruppe.name

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
}
# Assosier NSG til subnet1
resource "azurerm_network_interface_security_group_association" "ak1_nic1_nsg" {
  network_interface_id      = azurerm_network_interface.nic_subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg_for_subnet1.id
}

# Sette opp VM2 og tilhørende NSG regler.
# Lage VM2
resource "azurerm_linux_virtual_machine" "linux_02_subnet2" {
  name                = "Linux-02"
  resource_group_name = azurerm_resource_group.ak1_ressurs_gruppe.name
  location            = azurerm_resource_group.ak1_ressurs_gruppe.location
  size                = "Standard_B2as_v2"
  admin_username      = "adminuser2"
  admin_password      = "P@ssw0rd1234!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic_subnet2.id,
  ]

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

# NSG regler for subnet2
resource "azurerm_network_security_group" "nsg_for_subnet2" {
  name                = "NSG-for-subnet2"
  location            = azurerm_resource_group.ak1_ressurs_gruppe.location
  resource_group_name = azurerm_resource_group.ak1_ressurs_gruppe.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }
}

# Assosier NSG til subnet2
resource "azurerm_network_interface_security_group_association" "ak1_nic2_nsg" {
  network_interface_id      = azurerm_network_interface.nic_subnet2.id
  network_security_group_id = azurerm_network_security_group.nsg_for_subnet2.id
}

