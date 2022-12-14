output "dev_subscription" {
  description = "Subscription Id stored in dev Subscription"
  value       = data.azurerm_subscription.dev_subscription.id
}
output "prod_subscription" {
  description = "Subscription Id stored in dev Subscription"
  value       = data.azurerm_subscription.prod_subscription.id
}
output "id" {
  value = azurerm_mysql_flexible_server.mysqlsrv07.id
}
output "fqdn" {
  value = azurerm_mysql_flexible_server.mysqlsrv07.fqdn
}