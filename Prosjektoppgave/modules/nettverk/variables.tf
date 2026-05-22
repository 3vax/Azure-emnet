# variables.tf (nettverk)

variable "networks" {
  description = "Virtuelle nettverk med subnett"
  type = map(object({
    resource_group_name = string
    location            = string
    address_space       = list(string)

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
    name                = string
    resource_group_name = string
    location            = string
    allocation_method   = string
    sku                 = string
  }))
  default = {}
}