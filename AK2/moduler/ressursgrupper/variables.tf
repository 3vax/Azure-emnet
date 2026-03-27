# variables.tf (ressursgrupper)

variable "rg_name" {
    description = "Navn på ressursgruppen"
    type        = string
}

variable "location" {
	description = "Azure regionen hvor ressursene skal opprettes"
	type        = string
	
}