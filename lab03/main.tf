provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tfrg03" {
  name     = "${var.rgname03}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "tfvnet03" {
  name                = "${var.vnetname03}"
  resource_group_name = azurerm_resource_group.tfrg03.name
  location            = azurerm_resource_group.tfrg03.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.internalsnet03}-01"
  resource_group_name  = azurerm_resource_group.tfrg03.name
  virtual_network_name = azurerm_virtual_network.tfvnet03.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_windows_virtual_machine_scale_set" "tfvmss03" {
  name                = "tfvmss001"
  resource_group_name = azurerm_resource_group.tfrg03.name
  location            = azurerm_resource_group.tfrg03.location
  sku                 = "Standard_B1"
  instances           = 1
  admin_password      = "P@55w0rd1234!"
  admin_username      = "deivids"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter-Server-Core"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.internal.id
    }
  }
}
resource "azurerm_public_ip" "tfpip03" {
  name                = "${var.tfpip03}-01"
  location            = azurerm_resource_group.tfrg03.location
  resource_group_name = azurerm_resource_group.tfrg03.name
  allocation_method   = "Static"
}
resource "azurerm_lb" "tflb03" {
  name                = "${var.tflb03}-01"
  location            = azurerm_resource_group.tfrg03.location
  resource_group_name = azurerm_resource_group.tfrg03.name
  sku                 = "Standard"
  

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.tfpip03.id
  }
}
resource "azurerm_lb_rule" "lbrule03" {
  loadbalancer_id                 = azurerm_lb.tflb03.id
  name                            = "lb-https-rule-01"
  protocol                        = "Tcp"
  frontend_port                   = 80
  backend_port                    = 80
  frontend_ip_configuration_name  = "PublicIPAddress"
}
resource "azurerm_lb_probe" "lbprobe03" {
  loadbalancer_id = azurerm_lb.tflb03.id
  name            = "http-running-probe"
  port            = 80
}
resource "azurerm_lb_backend_address_pool" "backend-pool" {
  name            = "tflb03-backend-pool"
  loadbalancer_id = azurerm_lb.tflb03.id
}
resource "azurerm_lb_outbound_rule" "lboutboundrule" {
  name                    = "OutboundRule01"
  loadbalancer_id         = azurerm_lb.tflb03.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend-pool.id

  frontend_ip_configuration {
    name = "PublicIPAddress"
  }
}