resource "azurerm_resource_group" "terra-demo-02" {
  name = "rg-dev-tf-001"
  location = "var.location"
  tags = {
    CreatedBy = "Deivids",
    CostCenter = "IT Training"
  }
}

