# main.tf (scale-set)

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  instances           = var.instances
  admin_username      = var.vmss_admin_username
  custom_data         = base64encode(var.custom_data_content)

  health_probe_id = var.health_probe_id

  automatic_instance_repair {
    enabled      = var.enabled_automatic_repair
    grace_period = var.automatic_repair_grace_time
  }

  admin_ssh_key {
    username   = var.vmss_admin_username
    public_key = file(var.public_key_path)
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic-vmss"
    primary = true

    ip_configuration {
      name      = "ipconfig-vmss"
      primary   = true
      subnet_id = var.subnet_id

      load_balancer_backend_address_pool_ids = [
        var.backend_address_pool_id
      ]
    }
  }
}