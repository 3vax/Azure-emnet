# variables.tf (nsg)

variable "nsg_name" {
  description = "Navn på Network Security Group"
  type        = string
}

variable "resource_group_name" {
  description = "Navn på ressursgruppen NSG-en skal ligge i"
  type        = string
}

variable "location" {
  description = "Azure-regionen hvor NSG-en skal opprettes"
  type        = string
}

variable "subnet_id" {
  description = "ID til subnettet NSG-en skal kobles til"
  type        = string
}

variable "security_rules" {
  description = "NSG-regler som skal opprettes"
  type = map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}