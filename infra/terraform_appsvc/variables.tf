variable "project_name" { type = string }
variable "location"     { type = string  default = "japaneast" }


variable "rg_name" { type = string }

variable "vnet_rg"        { type = string }
variable "vnet_name"      { type = string }
variable "subnet_apps"    { type = string }  


variable "sql_hostname"   { type = string  description = "FQDN of SQL server (privatelink)" }
variable "sql_db_name"    { type = string }
variable "sql_user"       { type = string }
variable "sql_password"   { type = string  sensitive = true }

variable "appgw_public_ip" { type = string  description = "IPv4 of App Gateway public frontend" }

variable "appservice_plan_sku" { type = string  default = "P1v3" }
variable "frontend_app_name"   { type = string }
variable "backend_app_name"    { type = string }

variable "appinsights_location"       { type = string  default = "eastus" }
variable "appinsights_name"           { type = string  default = null }
variable "instrumentation_key"        { type = string  default = null }
variable "connection_string_appi"     { type = string  default = null }

variable "java_major_version" { type = number default = 17 }
