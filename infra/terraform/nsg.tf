resource "azurerm_network_security_group" "nsg_frontend" {
  name                = "nsg-frontend-najla"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "nsg_backend" {
  name                = "nsg-backend-najla"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "nsg_data" {
  name                = "nsg-data-najla"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "nsg_mgmt" {
  name                = "nsg-mgmt-najla"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_appgw_to_frontend_http" {
  name                        = "allow_appgw_to_frontend_http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = azurerm_subnet.snet["appgw"].address_prefixes[0]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_frontend.name
}

resource "azurerm_network_security_rule" "allow_appgw_to_backend_api" {
  name                        = "allow_appgw_to_backend_api"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = azurerm_subnet.snet["appgw"].address_prefixes[0]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_backend.name
}

resource "azurerm_network_security_rule" "allow_mgmt_ssh_frontend" {
  name                        = "allow_mgmt_ssh_frontend"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = azurerm_subnet.snet["mgmt"].address_prefixes[0]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_frontend.name
}

resource "azurerm_network_security_rule" "allow_mgmt_ssh_backend" {
  name                        = "allow_mgmt_ssh_backend"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = azurerm_subnet.snet["mgmt"].address_prefixes[0]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_backend.name
}

resource "azurerm_network_security_rule" "allow_backend_to_sql" {
  name                        = "allow_backend_to_sql"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = azurerm_subnet.snet["backend"].address_prefixes[0]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_data.name
}

resource "azurerm_subnet_network_security_group_association" "assoc_frontend" {
  subnet_id                 = azurerm_subnet.snet["frontend"].id
  network_security_group_id = azurerm_network_security_group.nsg_frontend.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_backend" {
  subnet_id                 = azurerm_subnet.snet["backend"].id
  network_security_group_id = azurerm_network_security_group.nsg_backend.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_data" {
  subnet_id                 = azurerm_subnet.snet["data"].id
  network_security_group_id = azurerm_network_security_group.nsg_data.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_mgmt" {
  subnet_id                 = azurerm_subnet.snet["mgmt"].id
  network_security_group_id = azurerm_network_security_group.nsg_mgmt.id
}

