

## Usage

```hcl
module "aks" {
  source = "../../"

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

unmanaged subnets

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
