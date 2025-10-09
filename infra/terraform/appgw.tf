resource "azurerm_application_gateway" "appgw" {
  name                = "${var.project_name}-appgw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ipcfg"
    subnet_id = azurerm_subnet.snet["appgw"].id
  }

  frontend_port {
    name = "port-80"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "public"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool { name = "frontend-pool" }
  backend_address_pool { name = "backend-pool" }

  probe {
    name                = "backend-probe"
    protocol            = "Http"
    path                = "/api/health"
    host                = "localhost"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
  }

  backend_http_settings {
    name                  = "frontend-http-settings"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
    cookie_based_affinity = "Disabled"
  }

  backend_http_settings {
    name                  = "backend-http-settings"
    port                  = 8080
    protocol              = "Http"
    request_timeout       = 30
    cookie_based_affinity = "Disabled"
    probe_name            = "backend-probe"
  }

  http_listener {
    name                           = "listener-80"
    frontend_ip_configuration_name = "public"
    frontend_port_name             = "port-80"
    protocol                       = "Http"
  }

  url_path_map {
    name                               = "pathmap01"
    default_backend_address_pool_name  = "frontend-pool"
    default_backend_http_settings_name = "frontend-http-settings"

    path_rule {
      name                       = "api"
      paths                      = ["/api/*"]
      backend_address_pool_name  = "backend-pool"
      backend_http_settings_name = "backend-http-settings"
    }
  }

  request_routing_rule {
    name               = "rule-path"
    rule_type          = "PathBasedRouting"
    http_listener_name = "listener-80"
    url_path_map_name  = "pathmap01"
    priority           = 110
  }

  firewall_policy_id = azurerm_web_application_firewall_policy.wafpolicy.id
}
