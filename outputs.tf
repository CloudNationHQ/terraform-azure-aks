output "subscription_id" {
  description = "contains the current subscription id"
  value       = data.azurerm_subscription.current.subscription_id
}

output "cluster" {
  description = "contains all aks configuration"
  value       = azurerm_kubernetes_cluster.aks
  sensitive   = true
}
