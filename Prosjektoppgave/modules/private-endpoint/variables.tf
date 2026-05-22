# variables.tf (private-endpoint)

variable "name" {
  description = "Navn på private endpoint"
  type        = string
}

variable "location" {
  description = "Azure-region"
  type        = string
}

variable "resource_group_name" {
  description = "Ressursgruppen private endpoint skal ligge i"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID hvor private endpoint skal plasseres"
  type        = string
}

variable "private_connection_resource_id" {
  description = "ID til ressursen private endpoint skal kobles til"
  type        = string
}

variable "subresource_names" {
  description = "Subresource for private endpoint, for eksempel file eller sqlServer"
  type        = list(string)
}

variable "private_dns_zone_ids" {
  description = "Private DNS zone ID-er som skal kobles til private endpoint"
  type        = list(string)
}

variable "private_dns_zone_group_name" {
  description = "Navn på private DNS zone group"
  type        = string
  default     = "default-dns-zone-group"
}