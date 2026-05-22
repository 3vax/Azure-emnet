# variables.tf (root)

variable "subscription_id" {
  description = "Subscription ID"
  type        = string
  #default	  = "CHANGE"
  #Hvis default ikke er satt henter den fra terraform.tfvars
}

variable "location" {
  description = "Azure regionen hvor ressursene skal opprettes"
  type        = string
  #default     = "France Central"

}

variable "ressursgrupper" {
  description = "Ressursgrupper som skal opprettes"
  type        = map(string)
}

variable "networks" {
  description = "Virtuelle nettverk og subnett"
  type = map(object({
    address_space = list(string)

    subnets = map(object({
      address_prefixes = list(string)

      delegation = optional(object({
        name = string

        service_delegation = object({
          name    = string
          actions = list(string)
        })
      }))
    }))
  }))
}

variable "public_ips" {
  description = "Public IP-adresser som skal opprettes"
  type = map(object({
    resource_group_key = string
    name               = string
    allocation_method  = string
    sku                = string
  }))
  default = {}
}

variable "loadbalancer" {
  description = "Konfigurasjon for Load Balancer"
  type = object({
    resource_group_key             = string
    public_ip_key                  = string
    lb_name                        = string
    sku                            = string
    frontend_ip_configuration_name = string
    backend_address_pool_name      = string

    probes = map(object({
      protocol     = string
      port         = number
      request_path = optional(string)
    }))

    rules = map(object({
      protocol      = string
      frontend_port = number
      backend_port  = number
      probe_key     = string
    }))
  })
}

variable "scale_set" {
  description = "Konfigurasjon for VM Scale Set"
  type = object({
    resource_group_key = string
    subnet_key         = string
    #backend_pool_key   = string
    custom_data_path = string

    vmss_name           = string
    sku                 = string
    instances           = number
    vmss_admin_username = string
    public_key_path     = string

    enabled_automatic_repair    = bool
    automatic_repair_grace_time = string
  })
}

variable "autoscale" {
  description = "Konfigurasjon for automatisk skalering av VMSS"
  type = object({
    autoscale_name          = string
    resource_group_key      = string
    profile_name            = string
    default_capacity        = number
    minimum_capacity        = number
    maximum_capacity        = number
    scale_out_cpu_threshold = number
    scale_in_cpu_threshold  = number
    scale_out_cooldown      = string
    scale_in_cooldown       = string
  })
}

variable "nsgs" {
  description = "Konfigurasjon for flere Network Security Groups"
  type = map(object({
    name               = string
    resource_group_key = string
    subnet_key         = string

    security_rules = map(object({
      priority               = number
      direction              = string
      access                 = string
      protocol               = string
      source_port_range      = string
      destination_port_range = string

      source_address_prefix      = optional(string)
      destination_address_prefix = optional(string)

      source_subnet_key      = optional(string)
      destination_subnet_key = optional(string)
    }))
  }))
}

variable "database" {
  description = "Konfigurasjon for Azure SQL Database"
  type = object({
    resource_group_key          = string
    sql_server_name             = string
    database_name               = string
    administrator_login         = string
    administrator_password      = string
    sku_name                    = string
    max_size_gb                 = number
    min_capacity                = number
    auto_pause_delay_in_minutes = number

    public_network_access_enabled = optional(bool, true)
  })

  sensitive = true
}

variable "filserver" {
  description = "Konfigurasjon for Azure Files filserver"
  type = object({
    resource_group_key       = string
    storage_account_name     = string
    account_tier             = string
    account_replication_type = string

    public_network_access_enabled = optional(bool, true)

    shares = map(object({
      quota = number
    }))
  })
}

variable "private_dns_zones" {
  description = "Private DNS zones som skal opprettes"
  type = map(object({
    resource_group_key = string
    zone_name          = string

    vnet_links = map(object({
      name     = string
      vnet_key = string
    }))
  }))
  default = {}
}

variable "private_endpoints" {
  description = "Private endpoints som skal opprettes"
  type = map(object({
    name                            = string
    resource_group_key              = string
    subnet_key                      = string
    private_connection_resource_key = string
    subresource_names               = list(string)
    private_dns_zone_key            = string
    private_dns_zone_group_name     = optional(string, "default-dns-zone-group")
  }))
  default = {}
}