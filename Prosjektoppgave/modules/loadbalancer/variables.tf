# variables.tf (loadbalancer)

variable "lb_name" {
  description = "Navn på lastbalanserer"
  type        = string
}

variable "location" {
  description = "Azure-regionen hvor ressursene skal opprettes"
  type        = string
}

variable "resource_group_name" {
  description = "Navn på ressursgruppen"
  type        = string
}

variable "sku" {
  description = "SKU for Load Balancer. Må normalt matche SKU på Public IP."
  type        = string
}

variable "frontend_ip_configuration_name" {
  description = "Navn på frontend IP-konfigurasjon"
  type        = string
}

variable "public_ip_address_id" {
  description = "ID for den offentlige IP-adressen som skal assosieres med Load Balancer"
  type        = string
}

variable "backend_address_pool_name" {
  description = "Navn på backend address pool"
  type        = string
}

variable "probes" {
  description = "Health probes for Load Balancer"
  type = map(object({
    protocol     = string
    port         = number
    request_path = optional(string)
  }))
}

variable "rules" {
  description = "Load balancing rules"
  type = map(object({
    protocol       = string
    frontend_port  = number
    backend_port   = number
    probe_key      = string
  }))
}