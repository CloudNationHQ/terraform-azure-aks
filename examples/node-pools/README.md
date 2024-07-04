This example demonstrates the use of multiple node pools, optimizing scalability and flexibility

## Usage

```hcl
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
```
