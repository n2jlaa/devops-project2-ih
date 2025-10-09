variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "admin_ssh_pubkey" {
  description = "Admin SSH public key"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL Server admin password"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Italy North"
}

variable "fe_ip" {
  description = "Frontend VM private IP"
  type        = string
  default     = "10.0.1.4"
}

variable "api_ip" {
  description = "Backend VM private IP"
  type        = string
  default     = "10.0.2.4"
}

variable "ops_ip" {
  description = "Ops VM private IP"
  type        = string
  default     = "10.0.5.4"
}
