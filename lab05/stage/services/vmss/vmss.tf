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
module "vmss05" {
  source = "/home/deivids/terraform-play/lab05/modules/services/vmss"
}