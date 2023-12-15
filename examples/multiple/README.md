This example demonstrates configuration and resource based outputs, highlighting their distinct purposes.

Consider the below module designed to create multiple clusters

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
  }
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

This below output example utilizes configuration based values from the local variable to provide specific information. By defining the output in this manner, details from the local configuration can be easily accessed in other modules:

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

This output allows direct referencing of specific configurations, for instance, `module.aks.clusters.cl1.name` and `module.aks.clusters.cl2.name`

To access data from an existing resource-level output, utilize the following output structure:

```hcl
output "clusters" {
  value = {
    for k, module_instance in module.aks : k => module_instance.cluster
  }
}
```

This method enables direct reference to resource-specific attributes, such as using `module.aks.clusters.cl1.id`, based on the predefined outputs at the resource level.
