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
  version = "~> 0.1"

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

module "analitics" {
  source  = "cloudnationhq/law/azure"
  version = "~> 0.1"

  law = {
    name          = module.naming.log_analytics_workspace.name
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
    node_pools    = local.node_pools
    profile       = "linux"
    dns_prefix    = "demo"

    default_node_pool = {
      vmsize         = "Standard_DS2_v2"
      vnet_subnet_id = module.network.subnets.db.id
    }

    maintenance_auto_upgrade = {
      disallowed = {
        w1 = {
          start = "2023-08-02T15:04:05Z"
          end   = "2023-08-05T20:04:05Z"
        }
      }

      config = {
        frequency   = "RelativeMonthly"
        interval    = "2"
        duration    = "5"
        week_index  = "First"
        day_of_week = "Tuesday"
        start_time  = "00:00"
      }
    }

    maintenance_node_os = {
      disallowed = {
        w1 = {
          start = "2023-08-02T15:04:05Z"
          end   = "2023-08-05T20:04:05Z"
        }
      }

      config = {
        frequency   = "Weekly"
        interval    = "2"
        duration    = "5"
        day_of_week = "Monday"
        start_time  = "00:00"
      }
    }

    maintenance = {
      allowed = {
        w1 = {
          day   = "Saturday"
          hours = ["1", "6"]
        }
        w2 = {
          day   = "Sunday"
          hours = ["1"]
        }
      }
    }

    workspace = {
      id = module.analytics.law.id
      enable = {
        oms_agent = true
        defender  = true
      }
    }

    profile = {
      network = {
        plugin            = "azure"
        load_balancer_sku = "standard"
        load_balancer = {
          idle_timeout_in_minutes   = 30
          managed_outbound_ip_count = 10
        }
      }
    }
  }
}
