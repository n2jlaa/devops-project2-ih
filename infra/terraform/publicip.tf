resource "azurerm_public_ip" "appgw_pip" {
  name                = "${var.project_name}-appgw-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
