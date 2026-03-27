variable "rg_name" {
    description = "Navn på ressursgruppen"
    type        = string
}

variable "location" {
    description = "Azure regionen hvor ressursene skal opprettes"
    type        = string
    #default     = "France Central"
}

variable "vm_names" {
    description = "Liste over navn på VM-er"
    type        = list(string)
    #default     = ["vm-01", "vm-02"]
}

variable "vm_admin_username" {
    description = "Administratorbrukernavn for virtuelle maskiner"
    type        = string
    #default     = "azureuser"
}

variable "vm_admin_password" {
    description = "Administratorpassord for virtuelle maskiner"
    type        = string
    #default     = "P@ssw0rd1234!"
}

variable "public_key_path" {
    description = "Filbane til SSH public key for VM-ene"
    type        = string
    #default     = "C:\\Users\\Hauk\\.ssh\\id_ed25519.pub"
}

variable "subnet_ids" {
    description = "Kart over subnettnavn til subnet-ID for VM-er"
    type        = map(string)
}

variable "subnet_names" {
    description = "Liste over subnet-navn for VM-tilknytning"
    type        = list(string)
}

variable "lb_backend_pool_ids" {
    description = "Liste over backend pool ID-er fra Load Balancer"
    type        = list(string)
}

variable "size" {
    description = "Størrelse på VM-ene"
    type        = string
    default     = "Standard_B2ats_v2"
}