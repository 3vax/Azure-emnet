# variables.tf (nettverk)

variable "rg_name" {
    description = "Navn på ressursgruppen"
    type        = string
}

variable "location" {
    description = "Azure regionen hvor ressursene skal opprettes"
    type        = string
}

variable "vnet_name" {
    description = "Navn på det virtuelle nettverket"
    type        = string
}

variable "ip_range" {
    description = "IP-adresseområdet for det virtuelle nettverket"
    type        = string
}

variable "subnet_names" {
    description = "Liste over navn på subnettene"
    type        = list(string)
}

variable "subnet_ip_ranges" {
    description = "Liste over IP-adresseområder for subnettene"
    type        = list(string)
}

variable "public_ip_name" {
    description = "Navn på den offentlige IP-adressen"
    type        = string
}

variable "existing_vnet_name" {
    description = "Navn på eksisterende virtuelt nettverk for peering"
    type        = string
}

variable "existing_vnet_resource_group_name" {
    description = "Navn på ressursgruppen til det eksisterende virtuelle nettverket"
    type        = string
}