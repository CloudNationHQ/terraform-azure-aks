This example showcases the implementation of maintenance windows

## Usage: automatic upgrades

```hcl
module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.6"

  keyvault = module.kv.vault.id

  cluster = {
    name          = module.naming.kubernetes_cluster.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    depends_on    = [module.kv]
    dns_prefix    = "demo"
    profile       = "linux"

    maintenance = {
      auto_upgrade = {
        disallowed = {
          w1 = {
            start = "2023-08-03T00:00:00Z"
            end   = "2023-08-06T00:00:00Z"
          }
        }

        frequency   = "RelativeMonthly"
        interval    = "3"
        duration    = "6"
        week_index  = "First"
        day_of_week = "Tuesday"
        start_time  = "00:00"
        utc_offset  = "+00:00"
      }
    }
  }
}
```

## Usage: node os

```hcl
module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.1"

  keyvault = module.kv.vault.id

  cluster = {
    name          = module.naming.kubernetes_cluster.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    depends_on    = [module.kv]
    dns_prefix    = "demo"
    profile       = "linux"

    maintenance = {
      node_os = {
        disallowed = {
          w1 = {
            start = "2023-08-03T00:00:00Z"
            end   = "2023-08-06T00:00:00Z"
          }
        }

        frequency   = "RelativeMonthly"
        interval    = "1"
        duration    = "6"
        week_index  = "First"
        day_of_week = "Tuesday"
        start_time  = "00:00"
        utc_offset  = "+00:00"
      }
    }
  }
}
```

## Usage general

```hcl
module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.1"

  keyvault = module.kv.vault.id

  cluster = {
    name          = module.naming.kubernetes_cluster.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    depends_on    = [module.kv]
    dns_prefix    = "demo"
    profile       = "linux"

    maintenance = {
      general = {
        allowed = {
          w1 = { day = "Saturday", hours = ["1", "6"] }
          w2 = { day = "Sunday", hours = ["1"] }
        }
      }
    }
  }
}
```
