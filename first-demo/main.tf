provider "azurerm" {
  version = "=1.35.0"
}

# Create a resource group
resource "azurerm_resource_group" "terra-demo-01" {
  name     = "rg-dev-terra-001"
  location = var.location
}