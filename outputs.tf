output "subscription_id" {
  description = "contains the current subscription id"
  value       = data.azurerm_subscription.this.subscription_id
}

output "cluster" {
  description = "contains all aks configuration"
  value       = azurerm_kubernetes_cluster.this
  sensitive   = true
}

output "identity" {
  description = "contains the cluster identity configuration"
  value       = one(azurerm_kubernetes_cluster.this.identity)
}
