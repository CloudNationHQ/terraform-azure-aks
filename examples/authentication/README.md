# Authentication

This displays authentication settings available for deployment.

## Types

```hcl
<<<<<<< HEAD
cluster = object({
  name               = string
  location           = string
  resourcegroup      = string
  node_resourcegroup = optional(string)
  depends_on         = optional(list(any))
  profile            = optional(string)
  dns_prefix         = optional(string)
  sku_tier           = optional(string)
  public_key         = optional(string)
  identity = optional(object({
    type = string
  }))
  default_node_pool = optional(object({
    upgrade_settings = optional(object({
      max_surge = optional(string)
    }))
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
    profile       = "linux"
    dns_prefix    = "demo"
  }
}
>>>>>>> main
```

## Notes

In a bring your own configuration, public_key is used for Linux clusters, while password is used for Windows clusters.

Both are optional; if omitted, the necessary credentials will be automatically generated.
