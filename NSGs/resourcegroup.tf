resource "azurerm_resource_group" "tf-nsg01" {
  name = "tf-nsg-001"
  location = var.location
  tags = {
    CreatedBy = "Deivids Egle"
    CostCenter = "Tf Training"
  }
}