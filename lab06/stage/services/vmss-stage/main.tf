provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg06" {
  name = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet06" {
  name                = "${var.prefix}-vnet"
  address_space = [ "10.10.0.0/16" ]
  resource_group_name = azurerm_resource_group.rg06.name
  location = azurerm_resource_group.rg06.location
}

resource "azurerm_subnet" "snet06" {
  name                 = "${var.prefix}-snet"
  address_prefixes = [ "10.10.2.0/24" ]
  virtual_network_name = azurerm_virtual_network.vnet06.name
  resource_group_name  = azurerm_resource_group.rg06.name
}

resource "azurerm_public_ip" "pip06" {
  location            = azurerm_resource_group.rg06.location
  name                = "${var.prefix}-pip"
  resource_group_name = azurerm_resource_group.rg06.name
  allocation_method   = "Dynamic"
  sku                 = "Standard"
  domain_name_label   = "${var.prefix}-dns"
}

resource "azurerm_lb" "lb06" {
  location            = azurerm_resource_group.rg06.location
  name                = "${var.prefix}-lb"
  resource_group_name = azurerm_resource_group.rg06.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip06.id
  }
}

resource "azurerm_lb_backend_address_pool" "pool-back-06" {
  loadbalancer_id     = azurerm_lb.lb06.id
  name                = "BackendAddressPool"
}

resource "azurerm_lb_nat_pool" "natpool06" {
  resource_group_name            = azurerm_resource_group.rg06.name
  name                           = "nat-poo"
  loadbalancer_id                = azurerm_lb.lb06.id
  protocol                       = "Tcp"
  frontend_port_start            = 80
  frontend_port_end              = 85
  backend_port                   = 8080
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "probe06" {
  name                = "ssh-running-probe"
  loadbalancer_id     = azurerm_lb.lb06.id
  port                = 22
}

resource "azurerm_lb_rule" "lb_rule06" {
  loadbalancer_id                = azurerm_lb.lb06.id
  probe_id                       = azurerm_lb_probe.probe06.id
  name                           = "lb06-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 85
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_linux_virtual_machine_scale_set" "lin-vmss-06" {
  name                = "${var.prefix}-vmss"
  resource_group_name = azurerm_resource_group.rg06.name
  location            = azurerm_resource_group.rg06.location
  sku                 = "Standard_B1s"
  instances           = 1
  admin_username      = "Deivids"
  admin_password = "Pa55word1!"

  disable_password_authentication = false
  
  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04-LTS"
    version = "latest"
  }


  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = format("%s-nic", var.prefix)
    primary = true

    ip_configuration {
      name      = format("%s-ipconfig", var.prefix)
      primary   = true
      subnet_id = azurerm_subnet.snet06.id

      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.pool-back-06.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.natpool06.id]
    }
  }
  # As noted in Terraform documentation https://www.terraform.io/docs/providers/azurerm/r/linux_virtual_machine_scale_set.html#load_balancer_backend_address_pool_ids
  depends_on = [azurerm_lb_rule.lb_rule06]
}
data "terraform_remote_state" "tfstate05" {
  backend = "azurerm"
  config = {
    resource_group_name = "${var.remote_state_rg}"
    storage_account_name   = "${var.remote_state_st_acc}"
    container_name         = "${var.tfstate_container}"
    key                    = "${var.remote_state_key}"
  }
}