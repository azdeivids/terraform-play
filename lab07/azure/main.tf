
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.34.0 "
    }
  }
}

provider "azurerm" {
  features {

  }
  subscription_id = var.dev_subscription
  alias           = "dev_subscription"
}
provider "azurerm" {
  features {

  }
  subscription_id = var.prod_subscription
  alias           = "prod_subscription"
}

data "azurerm_subscription" "dev_subscription" {
  provider = azurerm.dev_subscription
}
data "azurerm_subscription" "prod_subscription" {
  provider = azurerm.prod_subscription
}