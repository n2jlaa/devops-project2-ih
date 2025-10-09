resource "azurerm_application_insights" "appi" {
  name                = "najla-appi"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}
