output "subscription_id" {
  description = "contains the current subscription id"
  value       = data.azurerm_subscription.current.subscription_id
}

output "cluster" {
  description = "contains all aks configuration"
  value       = azurerm_kubernetes_cluster.aks
  sensitive   = true
}

output "identity" {
  description = "contains the user assigned identity configuration"
  value       = azurerm_kubernetes_cluster.aks.identity[0].type == "UserAssigned" && length(lookup(var.cluster.identity, "identity_ids", [])) == 0 ? azurerm_user_assigned_identity.cluster_identity["cluster"] : null
}
