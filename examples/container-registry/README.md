This example highlights integrating a container registry.

## Usage

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
    profile       = "linux"
    dns_prefix    = "demo"

    registry = {
      role_assignment_scope = module.registry.acr.id
    }
  }
}
```
