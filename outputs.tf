output "subscriptionId" {
  description = "contains the current subscription id"
  value       = data.azurerm_subscription.current.subscription_id
}

output "cluster" {
  description = "contains all aks configuration"
  value = {
    id   = azurerm_kubernetes_cluster.aks.id
    name = azurerm_kubernetes_cluster.aks.name
  }
}
