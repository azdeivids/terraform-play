terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "=3.34.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "terra-demo-02" {
  name = "rg-dev-tf-001"
  location = "uksouth"
  tags = {
    CreatedBy = "Deivids",
    CostCenter = "IT Training"
  }
}