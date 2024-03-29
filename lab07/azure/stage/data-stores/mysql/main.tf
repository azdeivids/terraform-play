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
module "mysql-flexible-server" {
  source = "/home/deivids/terraform-play/lab07/azure/modules/data-stores/mysql"

  providers = {
    azurerm.dev_subscription = azurerm.dev_subscription
  }

  rg_prefix                      = "tfrg"
  location                       = "UK South"
  pdnsz                          = false
  geo_redundant_backup_enabled   = false
  high_availability_standby_zone = 1
  db_username                    = var.db_username
  db_password                    = var.db_password

  remote_state_rg     = var.remote_state_rg
  remote_state_st_acc = var.remote_state_st_acc
  remote_state_cn     = var.remote_state_cn
  remote_state_key    = var.remote_state_key
}