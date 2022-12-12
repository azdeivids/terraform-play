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
module "vmss" {
    source = "/home/deivids/terraform-play/lab05/modules/services/vmss"
    
    remote_state_rg = var.remote_state_rg
    remote_state_st_acc = var.remote_state_st_acc
    remote_state_container = var.remote_state_container
    remote_state_key = var.remote_state_key
}