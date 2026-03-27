# variables.tf (network_security_groups)

variable "rg_name" {
    description = "Navn på ressursgruppen"
    type        = string
}

variable "location" {
	description = "Azure regionen hvor ressursene skal opprettes"
	type        = string
    #default     = "France Central"
	
}

variable "nsg_name_01" {
    description = "Navn på Network Security Group"
    type        = string
    #default     = "nsg-01"
}

variable "subnet_ids" {
    description = "Kart over subnettnavn til subnet-ID for NSG assosiasjon"
    type        = map(string)
}

variable "ssh_source_address_prefix" {
    description = "Kildeadresseprefix for SSH-tilgang"
    type        = string
    #default    = "192.168.50.0/24"
}    