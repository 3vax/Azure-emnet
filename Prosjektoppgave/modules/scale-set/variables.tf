# variables.tf (scale-set)

variable "resource_group_name" {
  description = "Navnet på ressursgruppen scale-set skal inn i"
  type        = string
}

variable "location" {
  description = "Azure-regionen hvor ressursene skal opprettes"
  type        = string
}

variable "vmss_name" {
  description = "Navn på scale set"
  type        = string
}

variable "sku" {
  description = "Hvilken VM-størrelse scale set skal bruke"
  type        = string
}

variable "instances" {
  description = "Antall instanser som skal opprettes ved start"
  type        = number
}

variable "vmss_admin_username" {
  description = "Brukernavn for administratorkonto til VMSS"
  type        = string
}

variable "public_key_path" {
  description = "Filsti til offentlig SSH-nøkkel"
  type        = string
}

variable "subnet_id" {
  description = "ID til subnettet VMSS skal plasseres i"
  type        = string
}

variable "backend_address_pool_id" {
  description = "ID til backend address pool for Load Balancer"
  type        = string
}

variable "custom_data_content" {
  description = "Innholdet i cloud-init-filen"
  type        = string
  sensitive   = true
}

variable "health_probe_id" {
  description = "ID til Load Balancer health probe som brukes for VMSS health og automatic instance repairs"
  type        = string
}

variable "enabled_automatic_repair" {
  description = "Aktiverer automatic instance repair for VMSS"
  type        = bool
  default     = false
}

variable "automatic_repair_grace_time" {
  description = "Hvor lenge VMSS skal vente før en usunn instans repareres. Må være mellom PT10M og PT90M"
  type        = string
  default     = "PT30M"
}