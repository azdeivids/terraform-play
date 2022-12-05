# User azurerm as the provider and deploy the resources within Uk South Region
provider "azurerm" {
  region = "uksouth"
}

variable "vmname" {
  default = "srvtfapp"
}
variable "rgname" {
  default = "tfvm-rg-dev"
}
variable "vnetname" {
  default = "uks-tfvnet"
}

resource "azurerm_resource_group" "tfrg01" {
  name = "${var.rgname}-001"
  location = "UK South"
}

resource "azurerm_virtual_network" "tfvnet01" {
  name = "${var.vnetname}-001"
  address_space = [ "10.10.0.0/16" ]
  location = azurerm_resource_group.tfrg01.location
  resource_group_name = azurerm_resource_group.tfrg01.name
}

resource "azurerm_subnet" "internal" {
  name = "${var.vnetname}-snet-01"
  resource_group_name = azurerm_resource_group.tfrg01.name
  virtual_network_name = azurerm_virtual_network.tfvnet01.name
  address_prefixes = [ "10.10.2.0/24" ]
}

resource "azurerm_network_interface" "tfint01" {
  name = "${var.vmname}-nic"
  location = azurerm_resource_group.tfrg01.location
  resource_group_name = azurerm_resource_group.tfrg01.name

  ip_configuration {
    name = "testconf01"
    subnet_id = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_virtual_machine" "tfvm01" {
  name = "${var.vmname}-001"
  location = azurerm_resource_group.tfrg01.location
  resource_group_name = azurerm_resource_group.tfrg01.name
  network_interface_ids = [azurerm_network_interface.tfint01.id]
  vm_size = "Standard_B1s"

  delete_data_disks_on_termination = true
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04-LTS"
    version = "latest"
    }
storage_os_disk {
  name = "myosdisk01"
  caching = "ReadWrite"
  create_option = "FromImage"
  managed_disk_type = "Standard_LRS"
  }
os_profile {
  computer_name = "hostname"
  admin_username = "deivids"
  admin_password = "Password1"
  }
os_profile_linux_config {
    disable_password_authentication = false
    }
tags = {
  "CreatedBy" = "Deivids"
  "CostCenter" = "IT Training"
  "Env" = "Staging"
  }
}
