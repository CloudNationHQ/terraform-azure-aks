locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["key_vault_secret", "subnet", "network_security_group"]
}

locals {
  cluster = {
    name           = module.naming.kubernetes_cluster.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    depends_on     = [module.kv]
    dns_prefix     = "demo"
    profile        = "linux"

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
      type = "UserAssigned"
      #identity_ids = [azurerm_user_assigned_identity.ua.id]
    }

    #kubelet_identity = {
    #user_assigned_identity_id = azurerm_user_assigned_identity.uakube.id
    #client_id                 = azurerm_user_assigned_identity.uakube.client_id
    #object_id                 = azurerm_user_assigned_identity.uakube.principal_id
    #}

    oms_agent = {
      log_analytics_workspace_id = module.analytics.workspace.id
    }

    microsoft_defender_atp = {
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

#resource "azurerm_user_assigned_identity" "ua" {
#name                = "uai-external"
#resource_group_name = module.rg.groups.demo.name
#location            = module.rg.groups.demo.location
#}

#resource "azurerm_user_assigned_identity" "uakube" {
#name                = "uai-kube"
#resource_group_name = module.rg.groups.demo.name
#location            = module.rg.groups.demo.location
#}

#resource "azurerm_role_assignment" "kubelet_identity_operator" {
#scope                = azurerm_user_assigned_identity.uakube.id
#role_definition_name = "Managed Identity Operator"
#principal_id         = azurerm_user_assigned_identity.ua.principal_id
#}
