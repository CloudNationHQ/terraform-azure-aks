This module enables flexible kubernetes cluster setup by supporting both auto generated and user supplied (bring your own) ssh keys and passwords for tailored access.

## Usage: generated password or ssh key

To utilize the generated password or ssh key, simply specify the key vault id in your configuration:

```hcl
module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.11"

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

## Usage: bringing your own password or ssh key

To use your own password or SSH key, use the below properties in your configuration:

```hcl
module "aks-linux" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.1"

  cluster = {
    name               = "${module.naming.kubernetes_cluster.name}-02"
    location           = module.rg.groups.demo.location
    resourcegroup      = module.rg.groups.demo.name
    node_resourcegroup = "${module.rg.groups.demo.name}-node02"
    depends_on         = [module.kv]
    profile            = "linux"
    dns_prefix         = "demo2"
    sku_tier           = "Standard"

    public_key = module.kv.tls_public_keys.tls.value
  }
}
```

```hcl
module "aks-windows" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.1"

  cluster = {
    name               = "${module.naming.kubernetes_cluster.name}-01"
    location           = module.rg.groups.demo.location
    resourcegroup      = module.rg.groups.demo.name
    node_resourcegroup = "${module.rg.groups.demo.name}-node01"
    depends_on         = [module.kv]
    profile            = "windows"
    dns_prefix         = "demo1"
    sku_tier           = "Standard"

    network_profile = {
      network_plugin = "azure"
    }

    password = module.kv.secrets.password.value
  }
}
```
