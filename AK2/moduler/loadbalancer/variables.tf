# variables.tf (loadbalancer)

variable "rg_name" {
    description = "Navn på ressursgruppen"
    type        = string
}

variable "location" {
	description = "Azure regionen hvor ressursene skal opprettes"
	type        = string
    #default     = "France Central"
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

variable "public_ip_id" {
    description = "ID for den offentlige IP-adressen som skal assosieres med Load Balancer"
    type        = string
}