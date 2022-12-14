terraform {
  required_providers {
    azurerm = {
        source = [hashicorp/azurerm]
        verversion = "~> 3.0.0 "        
    }
  }
}

provider "azurerm" {
  subscription_id = var.dev_subscription
  alias = "dev_subscription"
}
provider "azurerm" {
  subscription_id = var.prod_subscription
  alias = "prod_subscription"
}

data "azurerm_subscription" "dev_subscription" {
  provider = azurerm.dev_subscription
}
data "azurerm_subscription" "prod_subscription" {
  provider = azurerm.prod_subscription
}