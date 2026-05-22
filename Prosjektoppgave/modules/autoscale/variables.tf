# variables.tf (autoscale)

variable "autoscale_name" {
  description = "Navn på autoscale-innstillingen"
  type        = string
}

variable "resource_group_name" {
  description = "Ressursgruppen autoscale-innstillingen skal ligge i"
  type        = string
}

variable "location" {
  description = "Azure-region"
  type        = string
}

variable "target_resource_id" {
  description = "ID-en til ressursen som skal autoskaleres, for eksempel VMSS"
  type        = string
}

variable "profile_name" {
  description = "Navn på autoscale-profilen"
  type        = string
  default     = "default"
}

variable "default_capacity" {
  description = "Standard antall instanser"
  type        = number
}

variable "minimum_capacity" {
  description = "Minimum antall instanser"
  type        = number
}

variable "maximum_capacity" {
  description = "Maksimum antall instanser"
  type        = number
}

variable "scale_out_cpu_threshold" {
  description = "CPU-prosent som trigger scale out"
  type        = number
}

variable "scale_in_cpu_threshold" {
  description = "CPU-prosent som trigger scale in"
  type        = number
}

variable "scale_out_cooldown" {
  description = "Cooldown etter scale out"
  type        = string
  default     = "PT5M"
}

variable "scale_in_cooldown" {
  description = "Cooldown etter scale in"
  type        = string
  default     = "PT5M"
}