This example highlights the utilization of windows node pools.

## Usage

```hcl
module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.10"

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
```
