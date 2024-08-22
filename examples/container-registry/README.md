# Container Registry

This deploys the integration of a container registry within the cluster.

## Types

```hcl
cluster = object({
  name           = string
  location       = string
  resource_group = string
  depends_on     = list(any)
  profile        = string
  dns_prefix     = string
  identity = object({
    type = string
  })
  registry = optional(object({
    role_assignment_scope = string
  }))
  default_node_pool = object({
    upgrade_settings = object({
      max_surge = string
    })
  })
})
```

## Notes

If role_assignment_scope is defined in registry, the module creates an azurerm_role_assignment resource to assign the acrpull role to the kubernetes cluster's kubelet identity.
