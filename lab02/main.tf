terraform {
  required_providers {
    azurerm = {
        sousource = "hashicorp/azurerm"
        versiversion = "~> 3.0.0"
    }
  }
}
provider "azurerm" {
  features {}
}