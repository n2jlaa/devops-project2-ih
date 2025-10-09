variable "project_name" {
  type        = string
  description = "Project2 - SDA"
  default     = "project 2"
}
variable "admin_username" {
  description = "Admin username for the virtual machines"
  type        = string
  default     = "azureuser"
}

variable "location" {
  type        = string
  description = "Project 2 - location"
  default     = "japaneast"
}

variable "address_space" {
  type        = list(string)
  description = "VNet address space"
  default     = ["10.20.0.0/16"]
}

variable "appgw_id" {
  type        = string
  description = "Application Gateway resource ID"
}

variable "vm_frontend_id" {
  type        = string
  description = "Frontend VM resource ID"
}

variable "vm_backend_id" {
  type        = string
  description = "Backend VM resource ID"
}

variable "sql_db_id" {
  type        = string
  description = "SQL DB resource ID"
}

variable "subnets" {
  description = "Subnets CIDR blocks"
  type = map(object({
    cidr = string
  }))
  default = {
    appgw    = { cidr = "10.20.0.0/24" }
    frontend = { cidr = "10.20.1.0/24" }
    backend  = { cidr = "10.20.2.0/24" }
    data     = { cidr = "10.20.3.0/24" }
    mgmt     = { cidr = "10.20.10.0/24" }
    bastion  = { cidr = "10.20.100.0/27" }
  }
}

variable "ssh_public_key" {
  description = "Admin SSH public key (OpenSSH format)"
  type        = string
}
