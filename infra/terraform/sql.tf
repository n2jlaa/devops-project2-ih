# SQL Server
resource "azurerm_mssql_server" "sqlserver" {
  name                         = "${var.project_name}-sqlsrv"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssword123!"
}

# SQL Database
resource "azurerm_mssql_database" "sqldb" {
  name      = "${var.project_name}-db"
  server_id = azurerm_mssql_server.sqlserver.id
  sku_name  = "GP_Gen5_2"
}

# Private DNS Zone for SQL
resource "azurerm_private_dns_zone" "sqlzone" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

# Link DNS zone with VNet
resource "azurerm_private_dns_zone_virtual_network_link" "sqllink" {
  name                  = "sqlzone-vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.sqlzone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

# Private Endpoint
resource "azurerm_private_endpoint" "sqlpe" {
  name                = "${var.project_name}-sql-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.snet["data"].id

  private_service_connection {
    name                           = "sql-priv-conn"
    private_connection_resource_id = azurerm_mssql_server.sqlserver.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}

# Private DNS A record
resource "azurerm_private_dns_a_record" "sqlrecord" {
  name                = azurerm_mssql_server.sqlserver.name
  zone_name           = azurerm_private_dns_zone.sqlzone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sqlpe.private_service_connection[0].private_ip_address]
}
