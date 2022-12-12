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
}
module "vmss05" {
  source = "/home/deivids/terraform-play/lab05/modules/services/vmss"
  storage_account_name = "tfstate428150812"
  container_name = "tfstate02"
}