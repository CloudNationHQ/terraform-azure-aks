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
      name     = module.naming.resource_group.name
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

module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 3.0"

  keyvault = module.kv.vault.id

  cluster = {
    name           = module.naming.kubernetes_cluster.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    depends_on     = [module.kv]
    dns_prefix     = "demo"
    profile        = "linux"

    identity = {
      type = "UserAssigned"
    }

    default_node_pool = {
      upgrade_settings = {
        max_surge = "10%"
      }
    }

    maintenance_window = {
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
    maintenance_window_node_os = {
      frequency   = "RelativeMonthly"
      interval    = "1"
      duration    = "6"
      week_index  = "First"
      day_of_week = "Tuesday"
      start_time  = "00:00"
      utc_offset  = "+00:00"

      not_allowed = {
        w1 = {
          start = "2023-08-03T00:00:00Z"
          end   = "2023-08-06T00:00:00Z"
        }
      }
    }
    maintenance_window_auto_upgrade = {
      frequency   = "RelativeMonthly"
      interval    = "3"
      duration    = "6"
      week_index  = "First"
      day_of_week = "Tuesday"
      start_time  = "00:00"
      utc_offset  = "+00:00"

      not_allowed = {
        w1 = {
          start = "2023-08-03T00:00:00Z"
          end   = "2023-08-06T00:00:00Z"
        }
      }
    }
  }
}
