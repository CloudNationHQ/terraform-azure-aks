moved {
  from = data.azurerm_subscription.current
  to   = data.azurerm_subscription.this
}

moved {
  from = azurerm_kubernetes_cluster.aks
  to   = azurerm_kubernetes_cluster.this
}

moved {
  from = tls_private_key.tls_key["ssh_key"]
  to   = tls_private_key.this["this"]
}

moved {
  from = azurerm_key_vault_secret.tls_public_key_secret["ssh_key"]
  to   = azurerm_key_vault_secret.tls["pub"]
}

moved {
  from = azurerm_key_vault_secret.tls_private_key_secret["ssh_key"]
  to   = azurerm_key_vault_secret.tls["priv"]
}

moved {
  from = random_password.password["password"]
  to   = random_password.this["this"]
}

moved {
  from = azurerm_key_vault_secret.secret["password"]
  to   = azurerm_key_vault_secret.this["this"]
}

moved {
  from = azurerm_kubernetes_cluster_node_pool.pools
  to   = azurerm_kubernetes_cluster_node_pool.this
}

moved {
  from = azurerm_kubernetes_cluster_extension.ext
  to   = azurerm_kubernetes_cluster_extension.this
}

moved {
  from = azurerm_role_assignment.role
  to   = azurerm_role_assignment.this
}
