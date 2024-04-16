This example highlights the complete usage.

## Usage

```hcl
module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.7"

  keyvault = module.kv.vault.id
  cluster  = local.cluster
}
```

The module uses the below locals for configuration:

```hcl
locals {
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
      upgrade_settings = {
        max_surge = 50
      }
    }

    monitor_metrics = {
      labels_allowed      = "app,component,release"
      annotations_allowed = "kubernetes.io/ingress.class"
    }

    maintenance = {
      general = {
        allowed = {
          w1 = {
            day   = "Saturday"
            hours = ["1", "6"]
          }
          w2 = {
            day   = "Sunday",
            hours = ["1"]
          }
        }
      }
    }

    workspace = {
      id = module.analytics.workspace.id

      enable = {
        oms_agent               = true
        defender                = true
        msi_auth_for_monitoring = true
      }
    }

    key_vault_secrets_provider = {
      secret_rotation_enabled  = true
      secret_rotation_interval = "2m"
    }

    network_profile = {
      network_plugin      = "azure"
      network_plugin_mode = "overlay"
    }
  }
}
```

```hcl
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
```
