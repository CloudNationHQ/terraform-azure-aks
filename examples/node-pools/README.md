# Node Pools

This deploys multiple node pools

## Types

```hcl
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
```
