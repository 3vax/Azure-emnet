# variables.tf (vnet-peering)

variable "peerings" {
  description = "VNet-peerings som skal opprettes"
  type = map(object({
    resource_group_name       = string
    virtual_network_name      = string
    remote_virtual_network_id = string

    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, false)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
}