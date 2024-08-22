# Windows

This deploys a windows kubernetes cluster

## Types

```hcl
<<<<<<< HEAD
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
=======
module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.12"

  keyvault = module.kv.vault.id

  aks = {
    name          = module.naming.kubernetes_cluster.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    depends_on    = [module.kv]
    profile       = "windows"
    dns_prefix    = "demo"

    node_pools = {
      cache = {
        vmsize     = "Standard_DS2_v2"
        node_count = 2
        os_type    = "Windows"
      }
    }

    network = {
      plugin = "azure"
    }
  }
}
>>>>>>> main
```
