# Node Pools

This deploys multiple node pools

## Types

```hcl
<<<<<<< HEAD
cluster = object({
  name           = string
  location       = string
  resource_group = string
  depends_on     = list(any)
  node_pools = optional(map(object({
    vnet_subnet_id = optional(string)
    node_count     = optional(number)
    zones          = optional(list(number))
    mode           = optional(string)
    os_type        = optional(string)
    node_labels    = optional(map(string))
  })))
  dns_prefix = string
  profile    = string
  identity = object({
    type = string
  })
  default_node_pool = object({
    vnet_subnet_id = string
    upgrade_settings = object({
      max_surge = string
    })
  })
})
=======
module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.12"

  keyvault = module.kv.vault.id

  cluster = {
    name          = module.naming.kubernetes_cluster.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    depends_on    = [module.kv]
    node_pools    = local.node_pools
    dns_prefix    = "demo"
    profile       = "linux"


    default_node_pool = {
      vmsize         = "Standard_DS2_v2"
      vnet_subnet_id = module.network.subnets.db.id
    }
  }
}
```

The below configuration establishes distinct node pools for specific workloads, effectively utilizing subnet segmentation for network optimization.

```hcl
locals {
  node_pools = {
    db = {
      vmsize         = "Standard_F4s_v2"
      vnet_subnet_id = module.network.subnets.db.id
      node_count     = 2
      zones          = [1, 2]
      mode           = "User"
      node_labels = {
        "workload" = "database"
      }
    }
    cache = {
      vmsize         = "Standard_F4s_v2"
      vnet_subnet_id = module.network.subnets.cache.id
      node_count     = 2
      zones          = [1]
      node_labels = {
        "workload" = "cache"
      }
    }
  }
}
>>>>>>> main
```
