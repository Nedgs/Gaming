# Definition des ressources Azure

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.43.0"
    }
  }
  required_version = "1.3.7"
}

provider "azurerm" {
  features {}
  subscription_id = "72be4542-28e1-46c8-a32c-d416ad95f039"
  tenant_id       = "b7b023b8-7c32-4c02-92a6-c8cdaa1d189c"
}

resource "azurerm_resource_group" "gaming_1" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_service_plan" "gaming_1" {
  name                = var.asp_name
  location            = azurerm_resource_group.gaming_1.location
  resource_group_name = azurerm_resource_group.gaming_1.name
  os_type             = "Windows"
  sku_name            = var.asp_sku_name
}

resource "azurerm_windows_web_app" "gaming_1" {
  name                = var.app_name
  resource_group_name = azurerm_resource_group.gaming_1.name
  location            = azurerm_service_plan.gaming_1.location
  service_plan_id     = azurerm_service_plan.gaming_1.id

  site_config {
    application_stack {
      dotnet_version = var.dotnet_version
    }
  }
}

resource "azurerm_mssql_server" "db_server_1" {
  name                         = var.db_server_name
  resource_group_name          = azurerm_resource_group.gaming_1.name
  location                     = azurerm_service_plan.gaming_1.location
  version                      = "12.0"
  administrator_login          = var.db_login
  administrator_login_password = var.db_password

  tags = {
    environment = "production"
  }
}

resource "azurerm_storage_account" "db_account_1" {
  name                     = var.db_account_name
  resource_group_name      = azurerm_resource_group.gaming_1.name
  location                 = azurerm_service_plan.gaming_1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_database" "db_vm" {
  name           = var.db_name
  server_id      = azurerm_mssql_server.db_server_1.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false
}
