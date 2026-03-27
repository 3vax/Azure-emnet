# variables.tf (main)
variable "subscription_id" {
	description = "Subscription ID"
	type        = string
	#default	  = "4e57f55e-321b-4b84-8bc8-99cb86a0af29"
	#Hvis default ikke er satt henter den fra terraform.tfvars
}

variable "rg_name" {
    description = "Navn på ressursgruppen"
    type        = string
}

variable "location" {
	description = "Azure regionen hvor ressursene skal opprettes"
	type        = string
    #default     = "France Central"
	
}

variable "vnet_name" {
    description = "Navn på det virtuelle nettverket"
    type        = string
    #default     = "vnet_01"
}

variable "ip_range" {
    description = "IP-adresseområdet for det virtuelle nettverket"
    type        = string
    #default     = "192.168.50.0/24"
}

variable "subnet_names" {
    description = "Liste over navn på subnettene"
    type        = list(string)
    #default     = ["subnet_01", "subnet_02"]
}

variable "subnet_ip_ranges" {
    description = "Liste over IP-adresseområder for subnettene"
    type        = list(string)
    #default     = ["192.168.50.0/25", "192.168.50.128/25"]
}

variable "public_ip_name" {
    description = "Navn på den offentlige IP-adressen"
    type        = string
    #default     = "public_ip_01"
}

variable "existing_vnet_name" {
    description = "Navn på eksisterende virtuelt nettverk for peering"
    type        = string
}

variable "existing_vnet_resource_group_name" {
    description = "Navn på ressursgruppen til det eksisterende virtuelle nettverket"
    type        = string
}

variable "nsg_name_01" {
    description = "Navn på NSG"
    type        = string
    #default     = "nsg_01"
}

variable "ssh_source_address_prefix" {
    description = "Kildeadresseprefix for SSH-tilgang"
    type        = string
    #default     = "192.168.50.0/24"
}

variable "lb_name" {
    description = "Navn på Load Balancer"
    type        = string
    #default     = "lb_01"
}

variable "lb_frontend_name" {
    description = "Navn på frontend-ip-konfigurasjonen for Load Balancer"
    type        = string
    #default     = "PublicIPAddress"
}

variable "lb_backend_pool_names" {
    description = "Liste over navn på backend pooler for Load Balancer"
    type        = list(string)
    #default     = ["backend_pool_01", "backend_pool_02"]
}

variable "http_probe_name" {
    description = "Navn på HTTP health probe for Load Balancer"
    type        = string
    #default     = "http_probe_01"
}

variable "vm_names" {
    description = "Liste over navn på virtuelle maskiner"
    type        = list(string)
    #default     = ["vm_01", "vm_02"]
}

variable "vm_admin_username" {
    description = "Administratorbrukernavn for virtuelle maskiner"
    type        = string
    #default     = "azureuser"
}

variable "vm_admin_password" {
    description = "Administratorpassord for virtuelle maskiner"
    type        = string
    #default     = "P@ssw0rd1234!"
}

variable "public_key_path" {
    description = "Filbane til SSH public key for VM-ene"
    type        = string
    #default     = "C:\\Users\\Hauk\\.ssh\\id_ed25519.pub"
}

variable "size" {
    description = "Størrelse på VM-ene"
    type        = string
    default     = "Standard_B2ats_v2"
}
