output "cluster" {
  value     = module.aks.cluster
  sensitive = true
}

output "subscription_id" {
  value = module.aks.subscription_id
}
