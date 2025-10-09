
resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "frontend_assoc" {
  network_interface_id  = azurerm_network_interface.nic_frontend.id
  ip_configuration_name = "ipconfig1"

  backend_address_pool_id = one([
    for pool in azurerm_application_gateway.appgw.backend_address_pool : pool.id
    if pool.name == "frontend-pool"
  ])
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "backend_assoc" {
  network_interface_id  = azurerm_network_interface.nic_backend.id
  ip_configuration_name = "ipconfig1"

  backend_address_pool_id = one([
    for pool in azurerm_application_gateway.appgw.backend_address_pool : pool.id
    if pool.name == "backend-pool"
  ])
}
