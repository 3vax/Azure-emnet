# Lag en NSG i Azure
resource "azurerm_network_security_group" "nsg" {
    name                = var.nsg_name_01
    location            = var.location
    resource_group_name = var.rg_name

    security_rule {
        name                       = "Allow-SSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = var.ssh_source_address_prefix
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

    security_rule {
        name                       = "Allow-HTTPS"
        priority                   = 120
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

}

resource "azurerm_subnet_network_security_group_association" "assoc" {
    for_each = var.subnet_ids
    subnet_id                 = each.value
    network_security_group_id = azurerm_network_security_group.nsg.id
}
