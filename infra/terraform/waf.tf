resource "azurerm_web_application_firewall_policy" "wafpolicy" {
  name                = "${var.project_name}-waf-policy"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  policy_settings {
    enabled            = true
    mode               = "Prevention" 
    request_body_check = true
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}
