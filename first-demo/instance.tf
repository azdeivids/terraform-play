resource "azurerm_virtual_machine" "terra-demo-01" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.terra-demo-01.name
  network_interface_ids = [azurerm_network_interface.demo-instance.id]
  vm_size               = "Standard_B1s"


}