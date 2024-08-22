# Windows

This deploys a windows kubernetes cluster

## Types

```hcl
cluster = object({
  name           = string
  location       = string
  resource_group = string
  profile        = optional(string)
  dns_prefix     = optional(string)
  identity = optional(object({
    type = string
  }))
  node_pools = optional(map(object({
    name       = optional(string)
    vm_size    = optional(string)
    node_count = optional(number)
    os_type    = optional(string)
  })))
  network_profile = optional(object({
    network_plugin = optional(string)
  }))
})
```
