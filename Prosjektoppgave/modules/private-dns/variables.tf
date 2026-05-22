# variables.tf (private-dns)

variable "zone_name" {
  description = "Navn på Private DNS Zone"
  type        = string
}

variable "resource_group_name" {
  description = "Ressursgruppen Private DNS Zone skal ligge i"
  type        = string
}

variable "vnet_links" {
  description = "VNet som skal linkes til Private DNS Zone"
  type = map(object({
    name               = string
    virtual_network_id = string
  }))
}
