#output "cluster" {
#description = "contains all aks configuration"
#value       = azurerm_kubernetes_cluster.aks
#}

#output "cluster_id" {
#description = "The ID of the AKS cluster"
#value       = azurerm_kubernetes_cluster.aks.id
#}

output "subscriptionId" {
  description = "contains the current subscription id"
  value       = data.azurerm_subscription.current.subscription_id
}

output "cluster" {
  description = "Detailed information about the AKS cluster"
  value = {
    id   = azurerm_kubernetes_cluster.aks.id
    name = azurerm_kubernetes_cluster.aks.name
  }
}
