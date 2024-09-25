locals {
  node_pools = {
    db = {
      vnet_subnet_id = module.network.subnets.db.id
      node_count     = 2
      zones          = [1, 2]
      mode           = "User"
      os_type        = "Linux"

      config = {
        kubelet = {
          pod_max_pid = 110
        }
      }

      node_labels = {
        "workload" = "database"
      }
    }
    cache = {
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
