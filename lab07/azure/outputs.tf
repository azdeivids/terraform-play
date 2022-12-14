output "dev_subscription" {
  description = "Subscription Id stored in dev Subscription"
  value = data.azurerm_subscription.dev_subscription.id
}
output "prod_subscription" {
  description = "Subscription Id stored in dev Subscription"
  value = data.azurerm_subscription.prod_subscription.id
}
