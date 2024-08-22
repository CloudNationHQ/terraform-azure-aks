# Maintenance

This deploys maintenance windows

## Types

```hcl
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
```

## Notes

In addition to supporting multiple maintenance windows, it also allows explicit definitions for node_os and auto_upgrades as well.
