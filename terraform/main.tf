# Terraform
# Implementación de Grafana sobre Azure mediante App Services
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# Crear resource group para Grafana
resource "azurerm_resource_group" "rg" {
  name     = "rg-grafana-dev"
  location = "eastus2"
  tags = {
    environment = "Desarrollo"
    Team        = "DevOps"
  }
}
resource "azurerm_service_plan" "plan" {
  name                = "apsvgrafanafiztecdevplan01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "apsvgrafanafiztecdev01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.plan.location
  service_plan_id     = azurerm_service_plan.plan.id
  identity{
      type = "SystemAssigned"
  }

  site_config {}
}

resource "azurerm_container_registry" "acr" {
  name                = "azcrfiztecdev03"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "ra" {
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id
}

resource "azurerm_mariadb_server" "mariadb_server" {
  name                = "amdbservergrafanadev01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 51200
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  administrator_login          = var.mariadb_username
  administrator_login_password = var.mariadb_password
  version                      = "10.2"
  ssl_enforcement_enabled      = true
}

resource "azurerm_mariadb_database" "mariadb" {
  name                = "grafana"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mariadb_server.mariadb_server.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}