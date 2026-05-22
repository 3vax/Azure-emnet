# variables.tf (ressursgrupper)

variable "location" {
	description = "Azure regionen hvor ressursene skal opprettes"
	type        = string
	
}

variable "ressursgrupper" {
  description = "Ressursgrupper som skal opprettes"
  type        = map(string)
}