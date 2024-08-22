# Default

This example illustrates the default setup, in its simplest form.

## Types

```hcl
<<<<<<< HEAD
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
  default_node_pool = object({
    upgrade_settings = object({
      max_surge = string
    })
  })
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

The max_surge setting is defined as a workaround because each plan run resets upgrade_settings.max_surge for the default_node_pool. You can find more details about the issue [here](https://github.com/hashicorp/terraform-provider-azurerm/issues/24020)
