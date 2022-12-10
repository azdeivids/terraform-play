provider "azurerm" {
  features {}
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.34.0"
    }
  }
    backend "azurerm" {
        resource_group_name  = "terraform-state-storage-uksouth"
        storage_account_name = "tfstate428150812"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }

}
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}
resource "azurerm_mysql_flexible_server" "example" {
  name                   = "example-mysql-flexible-server-azdeivids1016"
  resource_group_name    = azurerm_resource_group.example.name
  location               = azurerm_resource_group.example.location
  administrator_login    = var.db_username
  administrator_password = var.db_password
  sku_name               = "B_Standard_B1s"
}

resource "azurerm_mysql_flexible_database" "example" {
  name                = "exampledb"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_flexible_server.example.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}