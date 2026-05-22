# terraform.tfvars (root)

# Provider og autentiseringsdetaljer
subscription_id = "CHANGE"
location        = "France Central"

# Ressursgrupper
ressursgrupper = {
  ecommerce = "rg-ecommerce",
  internt   = "rg-intern"
}

# Nettverksinstillinger for de forskjellige ressursgruppene
networks = {
  # VNET IP og subnet IP til ecommerce
  ecommerce = {
    address_space = ["10.10.0.0/16"]

    subnets = {
      subnet-web = {
        address_prefixes = ["10.10.1.0/24"]
      }
    }
  }

  # VNET IP og subnet IP til database og internt nettverk
  internt = {
    address_space = ["10.20.0.0/16"]

    subnets = {
      subnet-db = {
        address_prefixes = ["10.20.1.0/24"]

        delegation = {
          name = "mysql-flexible-server-delegation"

          service_delegation = {
            name = "Microsoft.DBforMySQL/flexibleServers"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action"
            ]
          }
        }
      }

      internt = {
        address_prefixes = ["10.20.2.0/24"]
      }
    }
  }
}

public_ips = {
  ecommerce = {
    resource_group_key = "ecommerce"
    name               = "pip-ecommerce"
    allocation_method  = "Static"
    sku                = "Standard"
  }
}

# Lastbalanser
loadbalancer = {
  resource_group_key             = "ecommerce"
  public_ip_key                  = "ecommerce"
  lb_name                        = "lb-ecommerce"
  sku                            = "Standard"
  frontend_ip_configuration_name = "frontend-ecommerce"
  backend_address_pool_name      = "backend-pool-ecommerce"

  probes = {
    http_probe = {
      protocol     = "Http"
      port         = 80
      request_path = "/"
    }
  }

  rules = {
    http_rule = {
      protocol      = "Tcp"
      frontend_port = 80
      backend_port  = 80
      probe_key     = "http_probe"
    }
  }
}

# VM scale-set
scale_set = {
  resource_group_key = "ecommerce"
  subnet_key         = "ecommerce-subnet-web"
  #backend_pool_key   = "ecommerce"

  vmss_name           = "vmss-web-ecommerce"
  sku                 = "Standard_B2als_v2"
  instances           = 2
  vmss_admin_username = "azureuser"
  public_key_path     = "Public key path"
  custom_data_path    = "cloud-init/web-app.yaml.tftpl"

  enabled_automatic_repair    = true
  automatic_repair_grace_time = "PT30M"
}

# Autoscale for VMSS
autoscale = {
  autoscale_name          = "autoscale-vmss-web"
  resource_group_key      = "ecommerce"
  profile_name            = "default"
  default_capacity        = 2
  minimum_capacity        = 2
  maximum_capacity        = 5
  scale_out_cpu_threshold = 70
  scale_in_cpu_threshold  = 25
  scale_out_cooldown      = "PT5M"
  scale_in_cooldown       = "PT10M"
}

# NSG regler og bundet mot det ecommerce nettverket
nsgs = {
  ecommerce-web = {
    name               = "nsg-ecommerce-web"
    resource_group_key = "ecommerce"
    subnet_key         = "ecommerce-subnet-web"

    security_rules = {
      allow_http_from_internet = {
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }

      allow_lb_probe = {
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "AzureLoadBalancer"
        destination_address_prefix = "*"
      }
    }
  }

  #  internt-private-endpoints = {
  #    name               = "nsg-internt-private-endpoints"
  #    resource_group_key = "internt"
  #    subnet_key         = "internt-subnet-private-endpoints"
  #
  #    security_rules = {
  #      allow_smb_from_ecommerce_web = {
  #        priority               = 100
  #        direction              = "Inbound"
  #        access                 = "Allow"
  #        protocol               = "Tcp"
  #        source_port_range      = "*"
  #        destination_port_range = "445"
  #
  #        source_subnet_key      = "ecommerce-subnet-web"
  #        destination_subnet_key = "internt-subnet-private-endpoints"
  #      }
  #
  #      allow_sql_from_ecommerce_web = {
  #        priority               = 110
  #        direction              = "Inbound"
  #        access                 = "Allow"
  #        protocol               = "Tcp"
  #        source_port_range      = "*"
  #        destination_port_range = "1433"
  #
  #        source_subnet_key      = "ecommerce-subnet-web"
  #        destination_subnet_key = "internt-subnet-private-endpoints"
  #      }
  #
  #      deny_other_vnet_inbound = {
  #        priority                   = 200
  #        direction                  = "Inbound"
  #        access                     = "Deny"
  #        protocol                   = "*"
  #        source_port_range          = "*"
  #        destination_port_range     = "*"
  #        source_address_prefix      = "VirtualNetwork"
  #        destination_address_prefix = "*"
  #      }
  #    }
  #  }
}

# Database
database = {
  resource_group_key     = "internt"
  sql_server_name        = "SQL SERVER NAME"
  database_name          = "ecommerce"
  administrator_login    = "USERNAME"
  administrator_password = "PASSWORD"

  public_network_access_enabled = true

  sku_name                    = "GP_S_Gen5_2"
  max_size_gb                 = 32
  min_capacity                = 0.5
  auto_pause_delay_in_minutes = 60
}

# Filserver
filserver = {
  resource_group_key       = "internt"
  storage_account_name     = "CHANGE_STORAGE_ACCOUNT_NAME"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = true

  shares = {
    app-media-share = {
      quota = 50
    }
    administrasjon-share = {
      quota = 100
    }
    developers-share = {
      quota = 100
    }
    sales-share = {
      quota = 100
    }
    customersupport-share = {
      quota = 100
    }
    shipping-share = {
      quota = 100
    }
    it-share = {
      quota = 100
    }
    backups = {
      quota = 200
    }
  }
}

private_dns_zones = {
  files = {
    resource_group_key = "internt"
    zone_name          = "privatelink.file.core.windows.net"

    vnet_links = {
      internt = {
        name     = "link-files-dns-internt"
        vnet_key = "internt"
      }

      ecommerce = {
        name     = "link-files-dns-ecommerce"
        vnet_key = "ecommerce"
      }
    }
  }

  sql = {
    resource_group_key = "internt"
    zone_name          = "privatelink.database.windows.net"

    vnet_links = {
      internt = {
        name     = "link-sql-dns-internt"
        vnet_key = "internt"
      }

      ecommerce = {
        name     = "link-sql-dns-ecommerce"
        vnet_key = "ecommerce"
      }
    }
  }
}

private_endpoints = {
  files = {
    name                            = "pe-files-ecommerce"
    resource_group_key              = "internt"
    subnet_key                      = "internt-subnet-private-endpoints"
    private_connection_resource_key = "filserver_storage_account"
    subresource_names               = ["file"]
    private_dns_zone_key            = "files"
    private_dns_zone_group_name     = "files-dns-zone-group"
  }

  sql = {
    name                            = "pe-sql-ecommerce"
    resource_group_key              = "internt"
    subnet_key                      = "internt-subnet-private-endpoints"
    private_connection_resource_key = "sql_server"
    subresource_names               = ["sqlServer"]
    private_dns_zone_key            = "sql"
    private_dns_zone_group_name     = "sql-dns-zone-group"
  }
}