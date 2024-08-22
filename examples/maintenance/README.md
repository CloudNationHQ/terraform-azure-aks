# Maintenance

This deploys maintenance windows

## Types

```hcl
<<<<<<< HEAD
cluster = object({
  name           = string
  location       = string
  resource_group = string
  depends_on     = list(any)
  dns_prefix     = string
  profile        = string
  identity = object({
    type = string
  })
  default_node_pool = object({
    upgrade_settings = object({
      max_surge = string
    })
  })
  maintenance_window = optional(object({
    allowed = optional(map(object({
      day   = string
      hours = list(string)
    })))
    not_allowed = optional(map(object({
      start = string
      end   = string
    })))
  }))
  maintenance_window_node_os = optional(object({
    frequency   = string
    interval    = string
    duration    = string
    week_index  = optional(string)
    day_of_week = optional(string)
    start_time  = optional(string)
    utc_offset  = optional(string)
    not_allowed = optional(map(object({
      start = string
      end   = string
    })))
  }))
  maintenance_window_auto_upgrade = optional(object({
    frequency   = string
    interval    = string
    duration    = string
    week_index  = optional(string)
    day_of_week = optional(string)
    start_time  = optional(string)
    utc_offset  = optional(string)
    not_allowed = optional(map(object({
      start = string
      end   = string
    })))
  }))
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
>>>>>>> main
```

## Notes

In addition to supporting multiple maintenance windows, it also allows explicit definitions for node_os and auto_upgrades as well.
