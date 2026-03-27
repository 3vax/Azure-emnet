##################################################
# FELLES INFRASTRUKTUR
##################################################

# Lag ressurs gruppe i Azure
module "ressursgruppe" {
    source = "./moduler/ressursgrupper"
    rg_name = var.rg_name
    location = var.location
}

# hente inn vlan, subnet og public ip
module "nettverk" {
    source = "./moduler/nettverk"
    rg_name = var.rg_name
    location = var.location
    vnet_name = var.vnet_name
    ip_range = var.ip_range
    subnet_names = var.subnet_names
    subnet_ip_ranges = var.subnet_ip_ranges
    public_ip_name = var.public_ip_name
    existing_vnet_resource_group_name = var.existing_vnet_resource_group_name
    existing_vnet_name = var.existing_vnet_name
    depends_on = [module.ressursgruppe]
}

# Hente inn NSG og assosiasjon til subnett
module "network_security_groups" {
    source = "./moduler/network_security_groups"
    rg_name = var.rg_name
    location = var.location
    nsg_name_01 = var.nsg_name_01
    ssh_source_address_prefix = var.ssh_source_address_prefix
    subnet_ids = module.nettverk.subnet_ids
    depends_on = [module.nettverk]
}


###################################################
## LOAD BALANCER
###################################################
module "loadbalancer" {
    source = "./moduler/loadbalancer"
    rg_name = var.rg_name
    location = var.location
    lb_name = var.lb_name
    lb_frontend_name = var.lb_frontend_name
    public_ip_id = module.nettverk.public_ip_id
    lb_backend_pool_names = var.lb_backend_pool_names
    http_probe_name = var.http_probe_name
    depends_on = [module.network_security_groups]
}

###################################################
## VM INSTANSER
###################################################

module "vm" {
    source = "./moduler/vm"
    rg_name = var.rg_name
    location = var.location
    vm_names = var.vm_names
    vm_admin_username = var.vm_admin_username
    vm_admin_password = var.vm_admin_password
    public_key_path = var.public_key_path
    subnet_ids = module.nettverk.subnet_ids
    subnet_names = var.subnet_names
    lb_backend_pool_ids = values(module.loadbalancer.backend_address_pool_ids)
    size = var.size
    depends_on = [module.loadbalancer]
}