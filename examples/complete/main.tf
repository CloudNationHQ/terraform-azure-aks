module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 0.1"

  naming = local.naming

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 1.0"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.18.0.0/16"]

    subnets = {
      db    = { cidr = ["10.18.1.0/24"] }
      cache = { cidr = ["10.18.2.0/24"] }
    }
  }
}

module "analytics" {
  source  = "cloudnationhq/law/azure"
  version = "~> 0.1"

  law = {
    name          = module.naming.log_analytics_workspace.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
  }
}

module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.1"

  keyvault = module.kv.vault.id

  cluster = {
    name          = module.naming.kubernetes_cluster.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    depends_on    = [module.kv]
    node_pools    = local.node_pools
    dns_prefix    = "demo"
    profile       = "linux"

    default_node_pool = {
      vmsize         = "Standard_DS2_v2"
      vnet_subnet_id = module.network.subnets.db.id
    }

    maintenance = {
      general = {
        allowed = {
          w1 = {
            day   = "Saturday"
            hours = ["1", "6"]
          }
          w2 = {
            day   = "Sunday",
            hours = ["1"]
          }
        }
      }
    }

    workspace = {
      id = module.analytics.workspace.id

      enable = {
        oms_agent               = true
        defender                = true
        msi_auth_for_monitoring = true
      }
    }

    key_vault_secrets_provider = {
      secret_rotation_enabled  = true
      secret_rotation_interval = "2m"
    }
  }
}
