module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "germanywestcentral"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 2.0"

  naming = local.naming

  vault = {
    name           = module.naming.key_vault.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
  }
}

module "acr" {
  source  = "cloudnationhq/acr/azure"
  version = "~> 3.0"

  registry = {
    name           = module.naming.container_registry.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    sku            = "Premium"
  }
}

module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 3.1"

  keyvault = module.kv.vault.id

  cluster = {
    name           = module.naming.kubernetes_cluster.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    depends_on     = [module.kv]
    profile        = "linux"
    dns_prefix     = "demo"

    identity = {
      type = "UserAssigned"
    }

    registry = {
      role_assignment_scope = module.acr.registry.id
    }

    default_node_pool = {
      upgrade_settings = {
        max_surge = "10%"
      }
    }
  }
}
