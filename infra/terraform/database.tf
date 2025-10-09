resource "azurerm_mssql_server" "sql" {
  name                         = "najlasqlserver"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "sqldb" {
  name                 = "najladb"
  server_id            = azurerm_mssql_server.sql.id
  sku_name             = "S0"
  max_size_gb          = 5
  storage_account_type = "Local"
}
