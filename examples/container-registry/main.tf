module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "identity" {
  source  = "cloudnationhq/uai/azure"
  version = "~> 2.0"

  config = {
    name                = module.naming.user_assigned_identity.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 4.0"

  naming = local.naming

  vault = {
    name                = module.naming.key_vault.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "acr" {
  source  = "cloudnationhq/acr/azure"
  version = "~> 5.0"

  registry = {
    name                = module.naming.container_registry.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    sku                 = "Premium"
  }
}

module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 4.0"

  keyvault = module.kv.vault.id

  cluster = {
    name                = module.naming.kubernetes_cluster.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    profile             = "linux"
    dns_prefix          = "demo"

    generate_ssh_key = {
      enable = true
    }

    identity = {
      type         = "UserAssigned"
      identity_ids = [module.identity.config.id]
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
  depends_on = [module.kv]
}
