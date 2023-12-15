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

module "aks" {
  source = "../../"

  keyvault = module.kv.vault.id

  cluster = {
    name          = module.naming.kubernetes_cluster.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    depends_on    = [module.kv]
    dns_prefix    = "demo"
    profile       = "linux"

    maintenance = {
      node_os = {
        disallowed = {
          w1 = {
            start = "2023-08-01T00:00:00Z"
            end   = "2023-08-06T00:00:00Z"
          }
        }

        frequency = "RelativeMonthly"
        interval  = "1"
        duration  = "6"
        week_index  = "First"
        day_of_week = "Tuesday"
        start_time = "00:00"
        utc_offset = "+00:00"
      }
    }
  }
}
