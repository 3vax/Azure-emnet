########################
#    Ressursgrupper    # 
########################

module "ressursgrupper" {
  source = "./modules/ressursgrupper"

  ressursgrupper = var.ressursgrupper
  location       = var.location
}

########################
#       Nettverk       # 
########################

module "nettverk" {
  source = "./modules/nettverk"

  networks = {
    for key, network in var.networks : key => {
      resource_group_name = module.ressursgrupper.ressursgrupper[key].name
      location            = module.ressursgrupper.ressursgrupper[key].location
      address_space       = network.address_space
      subnets             = network.subnets
    }
  }

  public_ips = {
    for key, pip in var.public_ips : key => {
      name                = pip.name
      resource_group_name = module.ressursgrupper.ressursgrupper[pip.resource_group_key].name
      location            = module.ressursgrupper.ressursgrupper[pip.resource_group_key].location
      allocation_method   = pip.allocation_method
      sku                 = pip.sku
    }
  }
}

module "nsg" {
  for_each = var.nsgs

  source = "./modules/nsg"

  nsg_name            = each.value.name
  resource_group_name = module.ressursgrupper.ressursgrupper[each.value.resource_group_key].name
  location            = module.ressursgrupper.ressursgrupper[each.value.resource_group_key].location
  subnet_id           = module.nettverk.subnets[each.value.subnet_key].id

  security_rules = {
    for rule_key, rule in each.value.security_rules : rule_key => {
      priority               = rule.priority
      direction              = rule.direction
      access                 = rule.access
      protocol               = rule.protocol
      source_port_range      = rule.source_port_range
      destination_port_range = rule.destination_port_range

      source_address_prefix = coalesce(
        try(rule.source_address_prefix, null),
        try(module.nettverk.subnets[rule.source_subnet_key].address_prefixes[0], null)
      )

      destination_address_prefix = coalesce(
        try(rule.destination_address_prefix, null),
        try(module.nettverk.subnets[rule.destination_subnet_key].address_prefixes[0], null)
      )
    }
  }
}

########################
#     LOADBALANCER     # 
########################

module "loadbalancer" {
  source = "./modules/loadbalancer"

  lb_name                        = var.loadbalancer.lb_name
  sku                            = var.loadbalancer.sku
  resource_group_name            = module.ressursgrupper.ressursgrupper[var.loadbalancer.resource_group_key].name
  location                       = module.ressursgrupper.ressursgrupper[var.loadbalancer.resource_group_key].location
  frontend_ip_configuration_name = var.loadbalancer.frontend_ip_configuration_name
  public_ip_address_id           = module.nettverk.public_ips[var.loadbalancer.public_ip_key].id
  backend_address_pool_name      = var.loadbalancer.backend_address_pool_name

  probes = var.loadbalancer.probes
  rules  = var.loadbalancer.rules
}

########################
#      Scale-Set       # 
########################

module "scale_set" {
  source = "./modules/scale-set"

  vmss_name           = var.scale_set.vmss_name
  resource_group_name = module.ressursgrupper.ressursgrupper[var.scale_set.resource_group_key].name
  location            = module.ressursgrupper.ressursgrupper[var.scale_set.resource_group_key].location
  sku                 = var.scale_set.sku
  instances           = var.scale_set.instances
  vmss_admin_username = var.scale_set.vmss_admin_username
  public_key_path     = var.scale_set.public_key_path

  health_probe_id = module.loadbalancer.probe_ids["http_probe"]

  enabled_automatic_repair    = var.scale_set.enabled_automatic_repair
  automatic_repair_grace_time = var.scale_set.automatic_repair_grace_time

  custom_data_content = templatefile(var.scale_set.custom_data_path, {
    storage_account_name = module.filserver.storage_account_name
    storage_account_key  = module.filserver.primary_access_key
    app_media_share      = module.filserver.share_names["app-media-share"]
  })

  subnet_id               = module.nettverk.subnets[var.scale_set.subnet_key].id
  backend_address_pool_id = module.loadbalancer.backend_address_pool_id

  depends_on = [
    module.database,
    module.loadbalancer,
    module.filserver,
    #    module.private_dns,
    #    module.private_endpoint,
    module.vnet_peering
  ]
}

module "autoscale" {
  source = "./modules/autoscale"

  autoscale_name      = var.autoscale.autoscale_name
  resource_group_name = module.ressursgrupper.ressursgrupper[var.autoscale.resource_group_key].name
  location            = module.ressursgrupper.ressursgrupper[var.autoscale.resource_group_key].location
  target_resource_id  = module.scale_set.vmss_id

  profile_name            = var.autoscale.profile_name
  default_capacity        = var.autoscale.default_capacity
  minimum_capacity        = var.autoscale.minimum_capacity
  maximum_capacity        = var.autoscale.maximum_capacity
  scale_out_cpu_threshold = var.autoscale.scale_out_cpu_threshold
  scale_in_cpu_threshold  = var.autoscale.scale_in_cpu_threshold
  scale_out_cooldown      = var.autoscale.scale_out_cooldown
  scale_in_cooldown       = var.autoscale.scale_in_cooldown
}

########################
#       Database       # 
########################

module "database" {
  source = "./modules/database"

  sql_server_name             = var.database.sql_server_name
  database_name               = var.database.database_name
  resource_group_name         = module.ressursgrupper.ressursgrupper[var.database.resource_group_key].name
  location                    = module.ressursgrupper.ressursgrupper[var.database.resource_group_key].location
  administrator_login         = var.database.administrator_login
  administrator_password      = var.database.administrator_password
  sku_name                    = var.database.sku_name
  max_size_gb                 = var.database.max_size_gb
  min_capacity                = var.database.min_capacity
  auto_pause_delay_in_minutes = var.database.auto_pause_delay_in_minutes

  public_network_access_enabled = var.database.public_network_access_enabled
}

########################
#       Filserver      # 
########################

module "filserver" {
  source = "./modules/filserver"

  storage_account_name     = var.filserver.storage_account_name
  resource_group_name      = module.ressursgrupper.ressursgrupper[var.filserver.resource_group_key].name
  location                 = module.ressursgrupper.ressursgrupper[var.filserver.resource_group_key].location
  account_tier             = var.filserver.account_tier
  account_replication_type = var.filserver.account_replication_type
  shares                   = var.filserver.shares

  public_network_access_enabled = var.filserver.public_network_access_enabled
}

########################
#     VNet Peering     #
########################

module "vnet_peering" {
  source = "./modules/vnet-peering"

  peerings = {
    ecommerce-to-internt = {
      resource_group_name       = module.ressursgrupper.ressursgrupper["ecommerce"].name
      virtual_network_name      = module.nettverk.vnets["ecommerce"].name
      remote_virtual_network_id = module.nettverk.vnets["internt"].id

      allow_virtual_network_access = true
    }

    internt-to-ecommerce = {
      resource_group_name       = module.ressursgrupper.ressursgrupper["internt"].name
      virtual_network_name      = module.nettverk.vnets["internt"].name
      remote_virtual_network_id = module.nettverk.vnets["ecommerce"].id

      allow_virtual_network_access = true
    }
  }
}

###############################################
#              Private Endpoints              #
#   Denne blir for komplisert for øyeblikket  #
###############################################

#locals {
#  private_endpoint_resource_ids = {
#    filserver_storage_account = module.filserver.storage_account_id
#    sql_server                = module.database.sql_server_id
#  }
#}
#
#module "private_dns" {
#  for_each = var.private_dns_zones
#
#  source = "./modules/private-dns"
#
#  zone_name           = each.value.zone_name
#  resource_group_name = module.ressursgrupper.ressursgrupper[each.value.resource_group_key].name
#
#  vnet_links = {
#    for link_key, link in each.value.vnet_links : link_key => {
#      name               = link.name
#      virtual_network_id = module.nettverk.vnets[link.vnet_key].id
#    }
#  }
#}
#
#module "private_endpoint" {
#  for_each = var.private_endpoints
#
#  source = "./modules/private-endpoint"
#
#  name                = each.value.name
#  location            = module.ressursgrupper.ressursgrupper[each.value.resource_group_key].location
#  resource_group_name = module.ressursgrupper.ressursgrupper[each.value.resource_group_key].name
#  subnet_id           = module.nettverk.subnets[each.value.subnet_key].id
#
#  private_connection_resource_id = local.private_endpoint_resource_ids[each.value.private_connection_resource_key]
#  subresource_names              = each.value.subresource_names
#
#  private_dns_zone_ids        = [module.private_dns[each.value.private_dns_zone_key].zone_id]
#  private_dns_zone_group_name = each.value.private_dns_zone_group_name
#
#  depends_on = [
#    module.private_dns
#  ]
#}