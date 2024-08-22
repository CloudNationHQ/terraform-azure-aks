module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev2"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "germanywestcentral"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 1.0"

  naming = local.naming

  vault = {
    name           = module.naming.key_vault.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
  }
}

module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 1.0"

  keyvault = module.kv.vault.id

  cluster = {
    name           = module.naming.kubernetes_cluster.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    depends_on     = [module.kv]
    profile        = "windows"
    dns_prefix     = "demo"

    identity = {
      type = "UserAssigned"
    }

    node_pools = {
      cache = {
        name       = "npdemo"
        vm_size    = "Standard_DS2_v2"
        node_count = 2
        os_type    = "Windows"
      }
    }

    network_profile = {
      network_plugin = "azure"
    }
  }
}
