locals {
  cluster = {
    name                = module.naming.kubernetes_cluster.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    dns_prefix          = "demo"
    profile             = "linux"

    generate_ssh_key = {
      enable = true
    }

    default_node_pool = {
      vm_size        = "Standard_DS2_v2"
      vnet_subnet_id = module.network.subnets.db.id
      upgrade_settings = {
        max_surge = 50
      }
    }

    monitor_metrics = {
      labels_allowed      = "app,component,release"
      annotations_allowed = "kubernetes.io/ingress.class"
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

    identity = {
      type         = "UserAssigned"
      identity_ids = [module.identity.config.id]
    }

    oms_agent = {
      log_analytics_workspace_id = module.analytics.workspace.id
    }

    microsoft_defender = {
      log_analytics_workspace_id = module.analytics.workspace.id
    }

    key_vault_secrets_provider = {
      secret_rotation_enabled  = true
      secret_rotation_interval = "2m"
    }

    network_profile = {
      network_plugin      = "azure"
      network_plugin_mode = "overlay"
      load_balancer_profile = {
        managed_outbound_ip_count = 2
      }
    }
    node_pools = {
      db = {
        vm_size        = "Standard_F4s_v2"
        vnet_subnet_id = module.network.subnets.db.id
        node_count     = 2
        zones          = [1, 2]
        mode           = "User"
        os_type        = "Linux"
        node_labels = {
          "workload" = "database"
        }
      }
      cache = {
        vm_size        = "Standard_F4s_v2"
        vnet_subnet_id = module.network.subnets.cache.id
        node_count     = 2
        zones          = [1]
        os_type        = "Linux"
        node_labels = {
          "workload" = "cache"
        }
      }
    }
  }
}
