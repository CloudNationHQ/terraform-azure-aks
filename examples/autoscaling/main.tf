module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.32"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "sweden central"
    }
  }
}

module "identity" {
  source  = "cloudnationhq/uai/azure"
  version = "~> 3.0"

  identity = {
    name                = module.naming.user_assigned_identity.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 6.0"

  vault = {
    name                = module.naming.key_vault.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 5.0"

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
      identity_ids = [module.identity.identity.id]
    }

    default_node_pool = {
      vm_size              = "Standard_DS2_v2"
      auto_scaling_enabled = true
      min_count            = 1
      max_count            = 3
    }

    auto_scaler_profile = {
      balance_similar_node_groups      = true
      expander                         = "random"
      max_graceful_termination_sec     = "600"
      scale_down_delay_after_add       = "10m"
      scale_down_unneeded              = "10m"
      scan_interval                    = "10s"
      skip_nodes_with_local_storage    = false
      skip_nodes_with_system_pods      = true
      empty_bulk_delete_max            = "10"
      new_pod_scale_up_delay           = "10s"
      max_unready_nodes                = 3
      max_unready_percentage           = 45
      scale_down_utilization_threshold = "0.5"
    }

    workload_autoscaler_profile = {
      keda_enabled                    = true
      vertical_pod_autoscaler_enabled = true
    }
  }
  depends_on = [module.kv]
}
