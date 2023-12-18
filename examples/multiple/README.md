This example demonstrates the use of both configuration and resource based outputs, in a multiple cluster setup.

## Usage

```hcl
module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.2"

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  keyvault   = module.kv.vault.id
  depends_on = [module.kv]

  for_each = local.clusters
  cluster  = each.value
}
```

The local variable defined below holds all our config.

```hcl
locals {
  clusters = {
    cl1 = {
      resourcegroup      = module.rg.groups.demo1.name
      location           = module.rg.groups.demo1.location
      node_resourcegroup = "rg-demo-dev-cl1-node"
      name               = "aks-demo-dev1"
      profile            = "linux"
      dns_prefix         = "cl1"
    }
    cl2 = {
      resourcegroup      = module.rg.groups.demo2.name
      location           = module.rg.groups.demo2.location
      node_resourcegroup = "rg-demo-dev-cl2-node"
      name               = "aks-demo-dev2"
      profile            = "linux"
      dns_prefix         = "cl2"
    }
  }
}
```

The below configuration based output shows how to retrieve values from this local variable.

```hcl
output "clusters" {
  value = {
    for cl_name, cl_config in local.clusters : cl_name => {
      name       = cl_config.name
      dns_prefix = cl_config.dns_prefix
    }
  }
}
```

From other modules this can be referenced like `module.aks.clusters.cl1.name` or `module.aks.clusters.cl2.name`

The below resource level based output can be used for example to get the cluster ids.

```hcl
output "clusters" {
  value = {
    for k, module_instance in module.aks : k => module_instance.cluster
  }
}
```

Now this can be referenced using `module.aks.clusters.cl1.id`
