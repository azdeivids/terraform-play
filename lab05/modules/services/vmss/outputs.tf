
output "public_ip_address" {
  value = data.azurerm_public_ip.azpip05.ip_address
}