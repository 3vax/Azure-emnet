# Lag NIC-er til VM-ene
resource "azurerm_network_interface" "vm_nic"{
    count               = length(var.vm_names)
    name                = "VM-${count.index + 1}-nic"
    location            = var.location
    resource_group_name = var.rg_name

    ip_configuration {
        name                          = "ipconfig-vm${count.index + 1}"
        subnet_id                     = var.subnet_ids[var.subnet_names[count.index]]
        private_ip_address_allocation = "Dynamic"
    }
}

# Assosier NIC-er til backend pool i load balancer
resource "azurerm_network_interface_backend_address_pool_association" "nic_backend_pool_assoc" {
    count                    = length(var.vm_names)
    ip_configuration_name    = "ipconfig-vm${count.index + 1}"
    network_interface_id     = azurerm_network_interface.vm_nic[count.index].id
    backend_address_pool_id  = var.lb_backend_pool_ids[0]
}

# Lage VM-er i Azure
resource "azurerm_linux_virtual_machine" "vm" {
    count               = length(var.vm_names)
    name                = var.vm_names[count.index]
    resource_group_name = var.rg_name
    location            = var.location
    size                = "Standard_B2ats_v2"
    admin_username      = var.vm_admin_username
    admin_password      = var.vm_admin_password
    network_interface_ids = [
        azurerm_network_interface.vm_nic[count.index].id,
    ]
    
    admin_ssh_key {
        username   = var.vm_admin_username
        public_key = file(var.public_key_path)
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