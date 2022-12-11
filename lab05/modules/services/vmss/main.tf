provider "azurerm" {
  features {}
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.34.0"
    }
  }
    backend "azurerm" {
        resource_group_name  = "terraform-state-storage-uksouth"
        storage_account_name = "tfstate428150812"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }

}

resource "azurerm_resource_group" "tfrg05" {
  name     = "${var.prefix}-resources"
  location = var.location
}

resource "azurerm_virtual_network" "vnet05" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tfrg05.location
  resource_group_name = azurerm_resource_group.tfrg05.name
}

resource "azurerm_subnet" "snet05-1" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.tfrg05.name
  virtual_network_name = azurerm_virtual_network.vnet05.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_network_security_group" "nsg05" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.tfrg05.location
  resource_group_name = azurerm_resource_group.tfrg05.name

  security_rule {
    name                       = "HTTP-in"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "nsgassoc05" {
  subnet_id                 = azurerm_subnet.snet05-1.id
  network_security_group_id = azurerm_network_security_group.nsg05.id
}

resource "azurerm_public_ip" "pip05" {
  name                = "${var.prefix}-pip"
  location            = azurerm_resource_group.tfrg05.location
  resource_group_name = azurerm_resource_group.tfrg05.name
  allocation_method   = "Dynamic"
  domain_name_label   = azurerm_resource_group.tfrg05.name
}

resource "azurerm_lb" "lb05" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.tfrg05.location
  resource_group_name = azurerm_resource_group.tfrg05.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip05.id
  }
}

resource "azurerm_lb_backend_address_pool" "lbpoolback05" {
  loadbalancer_id     = azurerm_lb.lb05.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lbprobe05" {
  loadbalancer_id     = azurerm_lb.lb05.id
  name                = "ssh-running-probe"
  protocol            = "Tcp"
  port                = 22
}

resource "azurerm_lb_nat_pool" "lbnat05" {
  resource_group_name            = azurerm_resource_group.tfrg05.name
  name                           = "http-pool"
  loadbalancer_id                = azurerm_lb.lb05.id
  protocol                       = "Tcp"
  frontend_port_start            = 80
  frontend_port_end              = 85
  backend_port                   = 8080
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss05" {
  name                = "${var.prefix}-vmss"
  resource_group_name = azurerm_resource_group.tfrg05.name
  location            = azurerm_resource_group.tfrg05.location
  sku                 = "Standard_B1s"
  instances           = 1
  admin_username      = "Deivids"
  admin_password      = "Pa55word1!"

  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic01"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.snet05-1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lbpoolback05.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnat05.id]
    }
  }

  depends_on = [azurerm_lb_probe.lbprobe05]
}
data "azurerm_public_ip" "azpip05" {
  name                = azurerm_public_ip.pip05.name
  resource_group_name = azurerm_resource_group.tfrg05.name
}
