# main.tf (nettverk)

# Lag virtuelt nettverk i Azure
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
  location            = var.location
  address_space       = [var.ip_range]
}

# Lag ett eller flere subnets i det virtuelle nettverket
resource "azurerm_subnet" "vnet_subnet" {
    count                = length(var.subnet_names)
    name                 = var.subnet_names[count.index]
    address_prefixes     = [var.subnet_ip_ranges[count.index]]
    virtual_network_name = azurerm_virtual_network.vnet.name
    resource_group_name  = var.rg_name
}

# Lag en public IP-adresse i Azure
resource "azurerm_public_ip" "public_ip" {
    name                = var.public_ip_name
    location            = var.location
    resource_group_name = var.rg_name
    allocation_method   = "Static"
}

# Hente inn eksisterende vnet for peering
data "azurerm_virtual_network" "existing_vnet" {
    name                = var.existing_vnet_name
    resource_group_name = var.existing_vnet_resource_group_name
}

# Opprett peering mellom det nye virtuelle nettverket og det eksisterende virtuelle nettverket
resource "azurerm_virtual_network_peering" "vnet_peering" {
    name                      = "${var.vnet_name}-to-${var.existing_vnet_name}-peering"
    resource_group_name       = var.rg_name
    virtual_network_name      = azurerm_virtual_network.vnet.name
    remote_virtual_network_id = data.azurerm_virtual_network.existing_vnet.id
    allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "existing_vnet_peering" {
    name                      = "${var.existing_vnet_name}-to-${var.vnet_name}-peering"
    resource_group_name       = var.existing_vnet_resource_group_name
    virtual_network_name      = data.azurerm_virtual_network.existing_vnet.name
    remote_virtual_network_id = azurerm_virtual_network.vnet.id
    allow_virtual_network_access = true
}
