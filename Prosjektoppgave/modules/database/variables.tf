# variables.tf (database)

variable "sql_server_name" {
  description = "Navn på Azure SQL logical server. Må være unikt i Azure."
  type        = string
}

variable "database_name" {
  description = "Navn på SQL-databasen"
  type        = string
}

variable "resource_group_name" {
  description = "Navn på ressursgruppen databasen skal ligge i"
  type        = string
}

variable "location" {
  description = "Azure-region"
  type        = string
}

variable "administrator_login" {
  description = "Administratorbruker for SQL-serveren"
  type        = string
}

variable "administrator_password" {
  description = "Administratorpassord for SQL-serveren"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "SKU for Azure SQL Database"
  type        = string
}

variable "max_size_gb" {
  description = "Maks databasestørrelse i GB"
  type        = number
}

variable "min_capacity" {
  description = "Minimum vCore-kapasitet for serverless database"
  type        = number
}

variable "auto_pause_delay_in_minutes" {
  description = "Antall minutter før serverless databasen auto-pauses"
  type        = number
}

variable "public_network_access_enabled" {
  description = "Om SQL-serveren skal tillate offentlig nettverkstilgang"
  type        = bool
  default     = true
}