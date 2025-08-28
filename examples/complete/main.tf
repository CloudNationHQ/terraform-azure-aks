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

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 9.0"

  naming = local.naming

  vnet = {
    name                = module.naming.virtual_network.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.18.0.0/16"]

    subnets = {
      db = {
        network_security_group = {}
        address_prefixes       = ["10.18.1.0/24"]
      }
      cache = {
        network_security_group = {}
        address_prefixes       = ["10.18.2.0/24"]
      }
    }
  }
}

module "analytics" {
  source  = "cloudnationhq/law/azure"
  version = "~> 3.0"

  workspace = {
    name                = module.naming.log_analytics_workspace.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 4.0"

  keyvault   = module.kv.vault.id
  cluster    = local.cluster
  depends_on = [module.kv]
}
