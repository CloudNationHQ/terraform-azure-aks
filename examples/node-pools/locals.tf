locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["key_vault_secret", "subnet", "network_security_group"]
}

locals {
  node_pools = {
    db = {
      vmsize         = "Standard_F4s_v2"
      vnet_subnet_id = module.network.subnets.db.id
      node_count     = 2
      zones          = [1, 2]
      mode           = "User"
      os_type        = "Linux"
      node_labels = {
        "workload" = "database"
      }
    }
    cache = {
      vmsize         = "Standard_F4s_v2"
      vnet_subnet_id = module.network.subnets.cache.id
      node_count     = 2
      zones          = [1]
      os_type        = "Linux"
      node_labels = {
        "workload" = "cache"
      }
    }
  }
}
