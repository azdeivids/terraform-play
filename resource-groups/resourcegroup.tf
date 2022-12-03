terraform {
  required_providers {
    azurerm = {
        sosource = "hashicorp/azurerm"
        versversion = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "terra-demo-02" {
  name = "rg-dev-tf-001"
  location = "var.location"
  tags = {
    CreatedBy = "Deivids",
    CostCenter = "IT Training"
  }
}

