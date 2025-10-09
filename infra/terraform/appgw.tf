############################################
# App Gateway (WAFv2) - Self-contained
############################################

# ==== INPUT VARS ====
variable "rg_name" {
  description = "Existing Resource Group name"
  type        = string
}

variable "vnet_name" {
  description = "Existing Virtual Network name"
  type        = string
}

variable "appgw_subnet_cidr" {
  description = "CIDR for dedicated App Gateway subnet (must be /27 or larger, non-overlapping)"
  type        = string
  default     = "10.0.10.0/27"
}

# ==== LOOKUP EXISTING RG & VNET ====
data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# ==== PUBLIC IP ====
resource "azurerm_public_ip" "appgw_pip" {
  name                = "appgw-public-ip"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ==== DEDICATED SUBNET FOR APPGW (no overlap; /27+) ====
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "appgw-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = [var.appgw_subnet_cidr]
}

# ==== WAF POLICY ====
resource "azurerm_web_application_firewall_policy" "wafpolicy" {
  name                = "appgw-waf-policy"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  policy_settings {
    enabled = true
    mode    = "Prevention"
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}

# ==== APPLICATION GATEWAY (WAF_v2) ====
resource "azurerm_application_gateway" "appgw" {
  name                = "appgw-najla"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ipcfg"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  frontend_port {
    name = "fe-port-80"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "fe-ip"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name = "be-pool"
  }

  backend_http_settings {
    name                  = "be-http"
    protocol              = "Http"
    port                  = 80
    request_timeout       = 30
    cookie_based_affinity = "Disabled"
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "fe-ip"
    frontend_port_name             = "fe-port-80"
    protocol                       = "Http"
  }

  # <<<<<< هنا مكان request_routing_rule >>>>>>
  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "be-pool"
    backend_http_settings_name = "be-http"
    priority                   = 100
  }

  firewall_policy_id = azurerm_web_application_firewall_policy.wafpolicy.id
}

# ==== OUTPUTS ====
#output "appgw_public_ip" {
# value = azurerm_public_ip.appgw_pip.ip_address
#}
