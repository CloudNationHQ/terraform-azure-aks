This example illustrates the default azure kubernetes service setup, in its simplest form.

## Usage: default

```hcl
module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.5"

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
```

Additionally, for certain scenarios, the example below highlights the ability to use multiple clusters, enabling a broader setup.

## Usage: multiple

```hcl
module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.1"

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location
  keyvault      = module.kv.vault.id
  depends_on    = [module.kv]

  for_each = local.clusters
  cluster  = each.value
}
```

The module uses a local to iterate, generating a cluster for each key. To avoid any problems you need to specify a seperate node resource group for each one.

```hcl
locals {
  clusters = {
    cl1 = {
      node_resource_group = "rg-demo-dev1-node"
      name                = "aks-demo-dev1"
      profile             = "linux"
      dns_prefix          = "cl1"
    }
    cl2 = {
      node_resource_group = "rg-demo-dev2-node"
      name                = "aks-demo-dev2"
      profile             = "linux"
      dns_prefix          = "cl2"
    }
  }
}
```
