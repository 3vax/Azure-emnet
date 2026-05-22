# variables.tf (filserver)

variable "storage_account_name" {
  description = "Navn på storage account. Må være globalt unikt og kun små bokstaver/tall."
  type        = string
}

variable "resource_group_name" {
  description = "Ressursgruppen storage account skal ligge i"
  type        = string
}

variable "location" {
  description = "Azure-region"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Replikeringstype"
  type        = string
  default     = "LRS"
}

variable "shares" {
  description = "Azure file shares som skal opprettes"
  type = map(object({
    quota = number
  }))
}

variable "public_network_access_enabled" {
  description = "Om storage account skal tillate offentlig nettverkstilgang"
  type        = bool
  default     = true
}