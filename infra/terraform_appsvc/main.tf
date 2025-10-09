locals {
  tags = {
    project = var.project_name
    stack   = "appsvc"
  }
}

data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

data "azurerm_subnet" "apps" {
  name                 = var.subnet_apps
  resource_group_name  = var.vnet_rg
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

resource "azurerm_application_insights" "appi" {
  count               = var.connection_string_appi == null && var.appinsights_name == null ? 1 : 0
  name                = "${var.project_name}-appi"
  location            = var.appinsights_location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "web"
  tags                = local.tags
}

resource "azurerm_service_plan" "plan" {
  name                = "${var.project_name}-plan"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.appservice_plan_sku
  tags                = local.tags
}

resource "azurerm_linux_web_app" "frontend" {
  name                = var.frontend_app_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = true
    ftps_state = "Disabled"
    application_stack {
      node_version = "20-lts"
    }
    health_check_path = "/"  
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITE_RUN_FROM_PACKAGE            = "1"
    WEBSITE_HTTPLOGGING_RETENTION_DAYS  = "7"
    APPINSIGHTS_INSTRUMENTATIONKEY      = coalesce(var.instrumentation_key, try(azurerm_application_insights.appi[0].instrumentation_key, null))
    APPLICATIONINSIGHTS_CONNECTION_STRING = coalesce(var.connection_string_appi, try(azurerm_application_insights.appi[0].connection_string, null))
  }

  tags = local.tags
}

resource "azurerm_linux_web_app" "backend" {
  name                = var.backend_app_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = true
    ftps_state = "Disabled"
    application_stack {
      java_version = format("%d", var.java_major_version) 
      java_server  = "JAVA"
    }
    health_check_path = "/actuator/health"
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE   = "false"
    WEBSITE_RUN_FROM_PACKAGE              = "1"
    SPRING_DATASOURCE_URL                 = "jdbc:sqlserver://${var.sql_hostname}:1433;database=${var.sql_db_name};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
    SPRING_DATASOURCE_USERNAME            = var.sql_user
    SPRING_DATASOURCE_PASSWORD            = var.sql_password
    APPINSIGHTS_INSTRUMENTATIONKEY        = coalesce(var.instrumentation_key, try(azurerm_application_insights.appi[0].instrumentation_key, null))
    APPLICATIONINSIGHTS_CONNECTION_STRING = coalesce(var.connection_string_appi, try(azurerm_application_insights.appi[0].connection_string, null))
  }

  tags = local.tags
}

resource "azurerm_app_service_virtual_network_swift_connection" "fe_vnet" {
  app_service_id = azurerm_linux_web_app.frontend.id
  subnet_id      = data.azurerm_subnet.apps.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "be_vnet" {
  app_service_id = azurerm_linux_web_app.backend.id
  subnet_id      = data.azurerm_subnet.apps.id
}

resource "azurerm_app_service_access_restriction" "fe_allow_agw" {
  web_app_id     = azurerm_linux_web_app.frontend.id
  name           = "allow-appgw"
  priority       = 100
  action         = "Allow"
  ip_address     = var.appgw_public_ip
  subnet_id      = null
  description    = "Allow inbound only from App Gateway"
}

resource "azurerm_app_service_access_restriction" "fe_deny_all" {
  web_app_id  = azurerm_linux_web_app.frontend.id
  name        = "deny-all"
  priority    = 65000
  action      = "Deny"
  description = "Default deny"
}

resource "azurerm_app_service_access_restriction" "be_allow_agw" {
  web_app_id     = azurerm_linux_web_app.backend.id
  name           = "allow-appgw"
  priority       = 100
  action         = "Allow"
  ip_address     = var.appgw_public_ip
  description    = "Allow inbound only from App Gateway"
}

resource "azurerm_app_service_access_restriction" "be_deny_all" {
  web_app_id  = azurerm_linux_web_app.backend.id
  name        = "deny-all"
  priority    = 65000
  action      = "Deny"
  description = "Default deny"
}

output "frontend_default_hostname" { value = azurerm_linux_web_app.frontend.default_hostname }
output "backend_default_hostname"  { value = azurerm_linux_web_app.backend.default_hostname }
