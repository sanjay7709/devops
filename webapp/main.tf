terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.42.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
    
  }
}

resource "azurerm_resource_group" "ModusETP" {
  name     = var.resource_group_name
  location = var.resource_group_location 
  tags = {
    "environment" = "production"
  }

}

resource "azurerm_app_service_plan" "sanapp1" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.ModusETP.location
  resource_group_name = azurerm_resource_group.ModusETP.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "sanwebapp" {
  name                = var.app_service_name
  location            = azurerm_resource_group.ModusETP.location
  resource_group_name = azurerm_resource_group.ModusETP.name
  app_service_plan_id = azurerm_app_service_plan.sanapp1.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}

resource "azurerm_sql_server" "sqldb" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.ModusETP.name
  location                     = azurerm_resource_group.ModusETP.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password

  tags = {
    environment = "production"
  }
}

resource "azurerm_sql_database" "example" {
  name                = var.sql_database_name
  resource_group_name = azurerm_resource_group.ModusETP.name
  location            = azurerm_resource_group.ModusETP.location
  server_name         = azurerm_sql_server.sqldb.name

  tags = {
    environment = "production"
  }
}