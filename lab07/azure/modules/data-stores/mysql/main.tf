terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.34.0 "
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.dev_subscription
  alias           = "dev_subscription"
}
provider "azurerm" {
  features {}

  subscription_id = var.prod_subscription
  alias           = "prod_subscription"
}

data "azurerm_subscription" "dev_subscription" {
  provider = azurerm.dev_subscription
}
data "azurerm_subscription" "prod_subscription" {
  provider = azurerm.prod_subscription
}
# generate random number
resource "random_string" "name" {
  length  = 5
  numeric = true
  special = false
}
# create resource group
resource "azurerm_resource_group" "rg07" {
  location = var.location
  name     = "${var.rg_prefix}-mysql-flexi"
}
# create virtual network
resource "azurerm_virtual_network" "vnet07" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg07.location
  name                = "${var.rg_prefix}-vnet"
  resource_group_name = azurerm_resource_group.rg07.name
}
# create subnet within vnet07
resource "azurerm_subnet" "snet07-1" {
  address_prefixes     = ["10.0.2.0/24"]
  name                 = "${var.rg_prefix}-snet"
  resource_group_name  = azurerm_resource_group.rg07.name
  virtual_network_name = azurerm_virtual_network.vnet07.name
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}
# manage private DNS with azure dns
resource "azurerm_private_dns_zone" "pdnsz07" {
  count               = var.pdnsz ? 1 : 0
  name                = "${var.rg_prefix}.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg07.name
}
# link private dns with vnet
resource "azurerm_private_dns_zone_virtual_network_link" "pdnsz-link07" {
  count                 = var.pdnsz ? 1 : 0
  name                  = "mysqlfsVnetZone${var.rg_prefix}.com"
  private_dns_zone_name = azurerm_private_dns_zone.pdnsz07.name
  resource_group_name   = azurerm_resource_group.rg07.name
  virtual_network_id    = azurerm_virtual_network.vnet07.id
}
# create the mysql flexible server
resource "azurerm_mysql_flexible_server" "mysqlsrv07" {
  location                     = azurerm_resource_group.rg07.location
  name                         = "mysqlfs-${random_string.name.result}"
  resource_group_name          = azurerm_resource_group.rg07.name
  administrator_login          = var.db_username
  administrator_password       = var.db_password
  backup_retention_days        = var.backup_retention_days
  delegated_subnet_id          = azurerm_subnet.snet07-1.id
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled ? 1 : 0
  private_dns_zone_id          = azurerm_private_dns_zone.pdnsz07.id
  sku_name                     = "GP_Standard_D2ds_v4"
  version                      = "8.0.21"
  zone                         = "1"

  high_availability {
    mode                      = "ZoneRedundant"
    standby_availability_zone = "2"
  }
  maintenance_window {
    day_of_week  = 0
    start_hour   = 8
    start_minute = 0
  }
  storage {
    iops    = 360
    size_gb = 20
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.default]
}
# create the mysql flexible server database
resource "azurerm_mysql_flexible_database" "mysqldb07" {
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
  name                = "mysqlfsdb_${random_string.name.result}"
  resource_group_name = azurerm_resource_group.rg07.name
  server_name         = azurerm_mysql_flexible_server.mysqlsrv07.name
}