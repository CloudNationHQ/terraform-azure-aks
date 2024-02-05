data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

# aks cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster.name
  resource_group_name = coalesce(lookup(var.cluster, "resourcegroup", null), var.resourcegroup)
  location            = coalesce(lookup(var.cluster, "location", null), var.location)

  kubernetes_version                  = try(var.cluster.version, null)
  sku_tier                            = try(var.cluster.sku, "Free")
  node_resource_group                 = try(var.cluster.node_resourcegroup, "${var.cluster.resourcegroup}-node")
  azure_policy_enabled                = try(var.cluster.enable.azure_policy, false)
  dns_prefix                          = try(var.cluster.dns_prefix, null)
  dns_prefix_private_cluster          = try(var.cluster.dns_prefix_private_cluster, null)
  automatic_channel_upgrade           = try(var.cluster.channel_upgrade, null)
  edge_zone                           = try(var.cluster.edge_zone, null)
  oidc_issuer_enabled                 = try(var.cluster.enable.oidc_issuer, false)
  private_cluster_enabled             = try(var.cluster.enable_private_cluster, false)
  open_service_mesh_enabled           = try(var.cluster.enable.service_mesh, false)
  run_command_enabled                 = try(var.cluster.enable.run_command, false)
  image_cleaner_enabled               = try(var.cluster.enable.image_cleaner, false)
  image_cleaner_interval_hours        = try(var.cluster.image_cleaner_interval_hours, 48)
  http_application_routing_enabled    = try(var.cluster.enable.http_application_routing, false)
  workload_identity_enabled           = try(var.cluster.enable.workload_identity, false)
  custom_ca_trust_certificates_base64 = try(var.cluster.custom_ca_trust_certificates_base64, [])

  local_account_disabled = try(var.cluster.rbac.local_account, true)

  # This defaults to Azure RBAC. The current user is set to admin by default
  dynamic "azure_active_directory_role_based_access_control" {
    for_each = local.role_based_access_control_enabled && local.rbac_aad_managed ? ["rbac"] : []

    content {
      admin_group_object_ids = local.rbac_aad_admin_group_object_ids
      azure_rbac_enabled     = local.rbac_aad_azure_rbac_enabled
      managed                = true
      tenant_id              = local.tenant_id
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = local.role_based_access_control_enabled && !local.rbac_aad_managed ? ["rbac"] : []

    content {
      client_app_id     = local.rbac_aad_client_app_id
      managed           = false
      server_app_id     = local.rbac_aad_server_app_id
      server_app_secret = local.rbac_aad_server_app_secret
      tenant_id         = local.tenant_id
    }
  }

  dynamic "network_profile" {
    for_each = try(var.cluster.network, null) != null ? { "default" = var.cluster.network } : {}

    content {
      network_plugin    = try(network_profile.value.plugin, null)
      network_mode      = try(network_profile.value.mode, null)
      network_policy    = try(network_profile.value.policy, null)
      dns_service_ip    = try(network_profile.value.dns_service_ip, null)
      outbound_type     = try(network_profile.value.outbound_type, null)
      pod_cidr          = try(network_profile.value.pod_cidr, null)
      service_cidr      = try(network_profile.value.service_cidr, null)
      load_balancer_sku = try(network_profile.value.load_balancer_sku, null)

      dynamic "load_balancer_profile" {
        for_each = try(network_profile.value.load_balancer, null) != null ? { "default" = network_profile.value.load_balancer } : {}

        content {
          managed_outbound_ip_count   = try(load_balancer_profile.value.managed_outbound_ip_count, null)
          outbound_ip_prefix_ids      = try(load_balancer_profile.value.outbound_ip_prefix_ids, null)
          outbound_ip_address_ids     = try(load_balancer_profile.value.outbound_ip_address_ids, null)
          outbound_ports_allocated    = try(load_balancer_profile.value.outbound_ports_allocated, null)
          idle_timeout_in_minutes     = try(load_balancer_profile.value.idle_timeout_in_minutes, null)
          managed_outbound_ipv6_count = try(load_balancer_profile.value.managed_outbound_ipv6_count, null)
        }
      }
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = lookup(var.cluster, "auto_scaler_profile", null) != null ? [var.cluster.auto_scaler_profile] : []

    content {
      balance_similar_node_groups      = try(auto_scaler_profile.value.balance_similar_node_groups, false)
      expander                         = try(auto_scaler_profile.value.expander, null)
      max_graceful_termination_sec     = try(auto_scaler_profile.value.max_graceful_termination_sec, null)
      max_node_provisioning_time       = try(auto_scaler_profile.value.max_node_provisioning_time, null)
      max_unready_nodes                = try(auto_scaler_profile.value.max_unready_nodes, null)
      max_unready_percentage           = try(auto_scaler_profile.value.max_unready_percentage, null)
      new_pod_scale_up_delay           = try(auto_scaler_profile.value.new_pod_scale_up_delay, null)
      scale_down_delay_after_add       = try(auto_scaler_profile.value.scale_down_delay_after_add, null)
      scale_down_delay_after_delete    = try(auto_scaler_profile.value.scale_down_delay_after_delete, null)
      scale_down_delay_after_failure   = try(auto_scaler_profile.value.scale_down_delay_after_failure, null)
      scan_interval                    = try(auto_scaler_profile.value.scan_interval, null)
      scale_down_unneeded              = try(auto_scaler_profile.value.scale_down_unneeded, null)
      scale_down_unready               = try(auto_scaler_profile.value.scale_down_unready, null)
      scale_down_utilization_threshold = try(auto_scaler_profile.value.scale_down_utilization_threshold, null)
      empty_bulk_delete_max            = try(auto_scaler_profile.value.empty_bulk_delete_max, null)
      skip_nodes_with_local_storage    = try(auto_scaler_profile.value.skip_nodes_with_local_storage, null)
      skip_nodes_with_system_pods      = try(auto_scaler_profile.value.skip_nodes_with_system_pods, null)
    }
  }

  dynamic "http_proxy_config" {
    for_each = try(var.cluster.proxy, null) != null ? { "default" = var.cluster.proxy } : {}

    content {
      http_proxy  = try(http_proxy_config.value.http, null)
      https_proxy = try(http_proxy_config.value.https, null)
      no_proxy    = try(http_proxy_config.value.exceptions, [])
      trusted_ca  = try(http_proxy_config.value.trusted_ca, null)
    }
  }

  dynamic "oms_agent" {
    for_each = (try(var.cluster.workspace.enable.oms_agent, false)) ? [var.cluster.workspace] : []
    content {
      log_analytics_workspace_id      = try(oms_agent.value.id, null)
      msi_auth_for_monitoring_enabled = try(oms_agent.value.enable.msi_auth_for_monitoring, false)
    }
  }

  dynamic "monitor_metrics" {
    for_each = var.monitor_metrics
    content {
      annotations_allowed = try(each.annotations_allowed, null)
      labels_allowed      = try(each.labels_allowed, null)
    }
  }

  dynamic "microsoft_defender" {
    for_each = (try(var.cluster.workspace.enable.defender, false)) ? { "defender" = true } : {}

    content {
      log_analytics_workspace_id = try(var.cluster.workspace.id, null)
    }
  }

  dynamic "service_mesh_profile" {
    for_each = try(var.cluster.profile.service_mesh, null) != null ? { "default" = var.cluster.profile.service_mesh } : {}

    content {
      # https://learn.microsoft.com/en-us/azure/aks/istio-deploy-addon#register-the-azureservicemeshpreview-feature-flag

      mode                             = try(service_mesh_profile.value.mode, false)
      internal_ingress_gateway_enabled = try(service_mesh_profile.value.internal_ingress_gateway_enabled, false)
      external_ingress_gateway_enabled = try(service_mesh_profile.value.external_ingress_gateway_enabled, false)
    }
  }

  dynamic "workload_autoscaler_profile" {
    for_each = try(var.cluster.profile.autoscaler, null) != null ? { "default" = var.cluster.profile.autoscaler } : {}

    content {
      # https://learn.microsoft.com/en-gb/azure/aks/keda-deploy-add-on-arm#register-the-aks-kedapreview-feature-flag
      # https://learn.microsoft.com/en-us/azure/aks/vertical-pod-autoscaler#register-the-aks-vpapreview-feature-flag

      keda_enabled                    = try(workload_autoscaler_profile.value.enable.keda, false)
      vertical_pod_autoscaler_enabled = try(workload_autoscaler_profile.value.enable.vertical_pod, false)
    }
  }

  dynamic "windows_profile" {
    for_each = var.cluster.profile == "windows" ? { "default" = {} } : {}

    content {
      admin_username = try(windows_profile.value.username, "nodeadmin")
      admin_password = azurerm_key_vault_secret.secret[windows_profile.key].value
    }
  }

  dynamic "linux_profile" {
    for_each = var.cluster.profile == "linux" ? { "default" = {} } : {}

    content {
      admin_username = try(linux_profile.value.username, "nodeadmin")
      ssh_key {
        key_data = azurerm_key_vault_secret.tls_public_key_secret[linux_profile.key].value
      }
    }
  }

  dynamic "maintenance_window" {
    for_each = try(var.cluster.maintenance.general, null) != null ? { "default" = var.cluster.maintenance.general } : {}

    content {
      dynamic "allowed" {
        for_each = {
          for k, v in try(var.cluster.maintenance.general.allowed, {}) : k => v
        }
        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }
      dynamic "not_allowed" {
        for_each = {
          for k, v in try(var.cluster.maintenance.general.disallowed, {}) : k => v
        }
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  dynamic "maintenance_window_node_os" {
    for_each = try(var.cluster.maintenance.node_os, null) != null ? { "default" = var.cluster.maintenance.node_os } : {}

    content {
      dynamic "not_allowed" {
        for_each = {
          for k, v in try(var.cluster.maintenance.node_os.disallowed, {}) : k => v
        }
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }

      frequency   = maintenance_window_node_os.value.frequency
      interval    = maintenance_window_node_os.value.interval
      duration    = maintenance_window_node_os.value.duration
      day_of_week = try(maintenance_window_node_os.value.day_of_week, null)
      week_index  = try(maintenance_window_node_os.value.week_index, null)
      start_time  = try(maintenance_window_node_os.value.start_time, null)
      utc_offset  = try(maintenance_window_node_os.value.utc_offset, null)
      start_date  = try(maintenance_window_node_os.value.start_date, null)
    }
  }

  dynamic "maintenance_window_auto_upgrade" {
    for_each = try(var.cluster.maintenance.auto_upgrade, null) != null ? { "default" = var.cluster.maintenance.auto_upgrade } : {}

    content {
      dynamic "not_allowed" {
        for_each = {
          for k, v in try(var.cluster.maintenance.auto_upgrade.disallowed, {}) : k => v
        }
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }

      frequency   = maintenance_window_auto_upgrade.value.frequency
      interval    = maintenance_window_auto_upgrade.value.interval
      duration    = maintenance_window_auto_upgrade.value.duration
      day_of_week = try(maintenance_window_auto_upgrade.value.day_of_week, null)
      week_index  = try(maintenance_window_auto_upgrade.value.week_index, null)
      start_time  = try(maintenance_window_auto_upgrade.value.start_time, null)
      utc_offset  = try(maintenance_window_auto_upgrade.value.utc_offset, null)
      start_date  = try(maintenance_window_auto_upgrade.value.start_date, null)
    }
  }

  default_node_pool {
    name           = try(var.cluster.default_node_pool.name, "default")
    vm_size        = try(var.cluster.default_node_pool.vmsize, "Standard_DS2_v2")
    node_count     = try(var.cluster.auto_scaler_profile, null) != null ? null : try(var.cluster.default_node_pool.node_count, 2)
    max_count      = try(var.cluster.default_node_pool.max_count, null)
    max_pods       = try(var.cluster.default_node_pool.max_pods, 30)
    min_count      = try(var.cluster.default_node_pool.min_count, null)
    zones          = try(var.cluster.default_node_pool.zones, [1, 2, 3])
    vnet_subnet_id = try(var.cluster.default_node_pool.vnet_subnet_id, null)
    node_labels    = try(var.cluster.default_node_pool.node_labels, {})
    tags           = try(var.cluster.default_node_pool.tags, {})

    custom_ca_trust_enabled       = try(var.cluster.default_node_pool.enable.custom_ca_trust, false)
    enable_auto_scaling           = try(var.cluster.default_node_pool.auto_scaling, false)
    enable_host_encryption        = try(var.cluster.default_node_pool.enable.host_encryption, false)
    enable_node_public_ip         = try(var.cluster.default_node_pool.enable.node_public_ip, false)
    fips_enabled                  = try(var.cluster.default_node_pool.enable.fips, null)
    only_critical_addons_enabled  = try(var.cluster.default_node_pool.enable.only_critical_addons, false)
    os_sku                        = try(var.cluster.default_node_pool.sku, null)
    type                          = try(var.cluster.default_node_pool.type, "VirtualMachineScaleSets")
    workload_runtime              = try(var.cluster.default_node_pool.workload_runtime, null)
    capacity_reservation_group_id = try(var.cluster.default_node_pool.capacity_reservation_group_id, null)
    proximity_placement_group_id  = try(var.cluster.default_node_pool.proximity_placement_group_id, null)
    node_public_ip_prefix_id      = try(var.cluster.default_node_pool.node_public_ip_prefix_id, null)
    scale_down_mode               = try(var.cluster.default_node_pool.scale_down_mode, null)
    pod_subnet_id                 = try(var.cluster.default_node_pool.pod_subnet_id, null)
    host_group_id                 = try(var.cluster.default_node_pool.host_group_id, null)
    message_of_the_day            = try(var.cluster.default_node_pool.message_of_the_day, null)
    ultra_ssd_enabled             = try(var.cluster.default_node_pool.ultra_ssd_enabled, false)
    orchestrator_version          = try(var.cluster.default_node_pool.orchestrator_version, null)
    os_disk_type                  = try(var.cluster.default_node_pool.os_disk_type, null)
    os_disk_size_gb               = try(var.cluster.default_node_pool.os_disk_size_gb, null)
    kubelet_disk_type             = try(var.cluster.default_node_pool.kubelet_disk_type, null)
    snapshot_id                   = try(var.cluster.default_node_pool.snapshot_id, null)
    temporary_name_for_rotation   = try(var.cluster.default_node_pool.temporary_name_for_rotation, null)

    dynamic "upgrade_settings" {
      for_each = {
        for k, v in try(var.cluster.node_pools.upgrade_settings, {}) : k => v
      }

      content {
        max_surge = upgrade_settings.value.default_node_pool.max_surge
      }
    }

    dynamic "linux_os_config" {
      for_each = length(try(var.cluster.default_node_pool.config.linux_os, {})) > 0 ? { "default" = var.cluster.default_node_pool.config.linux_os } : {}

      content {
        swap_file_size_mb = try(linux_os_config.value.swap_file_size_mb, null)
        dynamic "sysctl_config" {
          for_each = try(linux_os_config.value.sysctl_config, null) != null ? { "default" = linux_os_config.value.sysctl_config } : {}

          content {
            fs_aio_max_nr                      = try(sysctl_config.value.fs_aio_max_nr, null)
            fs_file_max                        = try(sysctl_config.value.fs_file_max, null)
            fs_inotify_max_user_watches        = try(sysctl_config.value.fs_inotify_max_user_watches, null)
            fs_nr_open                         = try(sysctl_config.value.fs_nr_open, null)
            kernel_threads_max                 = try(sysctl_config.value.kernel_threads_max, null)
            net_core_netdev_max_backlog        = try(sysctl_config.value.net_core_netdev_max_backlog, null)
            net_core_optmem_max                = try(sysctl_config.value.net_core_optmem_max, null)
            net_core_rmem_default              = try(sysctl_config.value.net_core_rmem_default, null)
            net_core_rmem_max                  = try(sysctl_config.value.net_core_rmem_max, null)
            net_core_somaxconn                 = try(sysctl_config.value.net_core_somaxconn, null)
            net_core_wmem_default              = try(sysctl_config.value.net_core_wmem_default, null)
            net_core_wmem_max                  = try(sysctl_config.value.net_core_wmem_max, null)
            net_ipv4_ip_local_port_range_max   = try(sysctl_config.value.net_ipv4_ip_local_port_range_max, null)
            net_ipv4_ip_local_port_range_min   = try(sysctl_config.value.net_ipv4_ip_local_port_range_min, null)
            net_ipv4_neigh_default_gc_thresh1  = try(sysctl_config.value.net_ipv4_neigh_default_gc_thresh1, null)
            net_ipv4_neigh_default_gc_thresh2  = try(sysctl_config.value.net_ipv4_neigh_default_gc_thresh2, null)
            net_ipv4_neigh_default_gc_thresh3  = try(sysctl_config.value.net_ipv4_neigh_default_gc_thresh3, null)
            net_ipv4_tcp_fin_timeout           = try(sysctl_config.value.net_ipv4_tcp_fin_timeout, null)
            net_ipv4_tcp_keepalive_intvl       = try(sysctl_config.value.net_ipv4_tcp_keepalive_intvl, null)
            net_ipv4_tcp_keepalive_probes      = try(sysctl_config.value.net_ipv4_tcp_keepalive_probes, null)
            net_ipv4_tcp_keepalive_time        = try(sysctl_config.value.net_ipv4_tcp_keepalive_time, null)
            net_ipv4_tcp_max_syn_backlog       = try(sysctl_config.value.net_ipv4_tcp_max_syn_backlog, null)
            net_ipv4_tcp_max_tw_buckets        = try(sysctl_config.value.net_ipv4_tcp_max_tw_buckets, null)
            net_ipv4_tcp_tw_reuse              = try(sysctl_config.value.net_ipv4_tcp_tw_reuse, null)
            net_netfilter_nf_conntrack_buckets = try(sysctl_config.value.net_netfilter_nf_conntrack_buckets, null)
            net_netfilter_nf_conntrack_max     = try(sysctl_config.value.net_netfilter_nf_conntrack_max, null)
            vm_max_map_count                   = try(sysctl_config.value.vm_max_map_count, null)
            vm_swappiness                      = try(sysctl_config.value.vm_swappiness, null)
            vm_vfs_cache_pressure              = try(sysctl_config.value.vm_vfs_cache_pressure, null)
          }
        }
        transparent_huge_page_defrag  = try(linux_os_config.value.transparent_huge_page_defrag, null)
        transparent_huge_page_enabled = try(linux_os_config.value.transparent_huge_page_enabled, null)
      }
    }

    dynamic "kubelet_config" {
      for_each = try(var.cluster.default_node_pool.config.kubelet, null) != null ? { "default" = var.cluster.default_node_pool.config.kubelet } : {}

      content {
        allowed_unsafe_sysctls    = try(kubelet_config.value.allowed_unsafe_sysctls, null)
        container_log_max_line    = try(kubelet_config.value.container_log_max_line, null)
        container_log_max_size_mb = try(kubelet_config.value.container_log_max_size_mb, null)
        cpu_cfs_quota_enabled     = try(kubelet_config.value.cpu_cfs_quota_enabled, null)
        cpu_cfs_quota_period      = try(kubelet_config.value.cpu_cfs_quota_period, null)
        cpu_manager_policy        = try(kubelet_config.value.cpu_manager_policy, "none")
        image_gc_high_threshold   = try(kubelet_config.value.image_gc_high_threshold, null)
        image_gc_low_threshold    = try(kubelet_config.value.image_gc_low_threshold, null)
        pod_max_pid               = try(kubelet_config.value.pod_max_pid, null)
        topology_manager_policy   = try(kubelet_config.value.topology_manager_policy, null)
      }
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

# secrets
resource "tls_private_key" "tls_key" {
  for_each = var.cluster.profile == "linux" ? { "default" = {} } : {}

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "tls_public_key_secret" {
  for_each = var.cluster.profile == "linux" ? { "default" = {} } : {}

  name         = format("%s-%s-%s", "kvs", var.cluster.name, "pub")
  value        = tls_private_key.tls_key[each.key].public_key_openssh
  key_vault_id = var.keyvault
}

resource "azurerm_key_vault_secret" "tls_private_key_secret" {
  for_each = var.cluster.profile == "linux" ? { "default" = {} } : {}

  name         = format("%s-%s-%s", "kvs", var.cluster.name, "prv")
  value        = tls_private_key.tls_key[each.key].private_key_pem
  key_vault_id = var.keyvault
}

# random password
resource "random_password" "password" {
  for_each = var.cluster.profile == "windows" ? { "default" = {} } : {}

  length      = 24
  special     = true
  min_lower   = 5
  min_upper   = 7
  min_special = 4
  min_numeric = 5
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = var.cluster.profile == "windows" ? { "default" = {} } : {}

  name         = format("%s-%s", "kvs", var.cluster.name)
  value        = random_password.password[each.key].result
  key_vault_id = var.keyvault
}

# node pools
resource "azurerm_kubernetes_cluster_node_pool" "pools" {
  for_each = {
    for pools in local.aks_pools : pools.pools_key => pools
  }

  name                    = each.value.poolname
  kubernetes_cluster_id   = each.value.aks_cluster_id
  vm_size                 = each.value.vmsize
  max_count               = each.value.max_count
  min_count               = each.value.min_count
  node_count              = each.value.node_count
  custom_ca_trust_enabled = each.value.custom_ca_trust

  zones                         = each.value.availability_zones
  enable_auto_scaling           = each.value.enable_auto_scaling
  enable_host_encryption        = each.value.enable_host_encryption
  enable_node_public_ip         = each.value.enable_node_public_ip
  fips_enabled                  = each.value.enable_fips
  eviction_policy               = each.value.eviction_policy
  kubelet_disk_type             = each.value.kubelet_disk_type
  os_disk_size_gb               = each.value.os_disk_size_gb
  os_disk_type                  = each.value.os_disk_type
  orchestrator_version          = each.value.orchestrator_version
  ultra_ssd_enabled             = each.value.ultra_ssd_enabled
  message_of_the_day            = each.value.message_of_the_day
  host_group_id                 = each.value.host_group_id
  pod_subnet_id                 = each.value.pod_subnet_id
  spot_max_price                = each.value.spot_max_price
  scale_down_mode               = each.value.scale_down_mode
  node_public_ip_prefix_id      = each.value.node_public_ip_prefix_id
  proximity_placement_group_id  = each.value.proximity_placement_group_id
  capacity_reservation_group_id = each.value.capacity_reservation_group_id
  max_pods                      = each.value.max_pods
  mode                          = each.value.mode
  node_labels                   = each.value.node_labels
  node_taints                   = each.value.node_taints
  os_sku                        = each.value.os_sku
  os_type                       = each.value.os_type
  priority                      = each.value.priority
  snapshot_id                   = each.value.snapshot_id
  workload_runtime              = each.value.workload_runtime
  vnet_subnet_id                = each.value.vnet_subnet_id

  dynamic "windows_profile" {
    for_each = each.value.os_type == "windows" ? [1] : []
    content {
      outbound_nat_enabled = each.value.windows_profile.outbound_nat_enabled
    }
  }

  dynamic "upgrade_settings" {
    for_each = {
      for k, v in try(each.value.node_pools, {}) : k => v
    }

    content {
      max_surge = each.value.upgrade_settings.max_surge
    }
  }

  dynamic "linux_os_config" {
    for_each = each.value.os_type == "linux" && each.value.linux_os_config != null ? { "config" = each.value.linux_os_config } : {}

    content {
      swap_file_size_mb = try(linux_os_config.value.allowed_unsafe_sysctls, null)

      dynamic "sysctl_config" {
        for_each = try(linux_os_config.value.sysctl_config, null) != null ? { "default" = linux_os_config.value.sysctl_config } : {}
        content {
          fs_aio_max_nr                      = try(sysctl_config.value.fs_aio_max_nr, null)
          fs_file_max                        = try(sysctl_config.value.fs_file_max, null)
          fs_nr_open                         = try(sysctl_config.value.fs_nr_open, null)
          fs_inotify_max_user_watches        = try(sysctl_config.value.fs_inotify_max_user_watches, null)
          kernel_threads_max                 = try(sysctl_config.value.kernel_threads_max, null)
          net_core_netdev_max_backlog        = try(sysctl_config.value.net_core_netdev_max_backlog, null)
          net_core_optmem_max                = try(sysctl_config.value.net_core_optmem_max, null)
          net_core_rmem_default              = try(sysctl_config.value.net_core_rmem_default, null)
          net_core_rmem_max                  = try(sysctl_config.value.net_core_rmem_max, null)
          net_core_somaxconn                 = try(sysctl_config.value.net_core_somaxconn, null)
          net_core_wmem_default              = try(sysctl_config.value.net_core_wmem_default, null)
          net_core_wmem_max                  = try(sysctl_config.value.net_core_wmem_max, null)
          net_ipv4_ip_local_port_range_max   = try(sysctl_config.value.net_ipv4_ip_local_port_range_max, null)
          net_ipv4_ip_local_port_range_min   = try(sysctl_config.value.net_ipv4_ip_local_port_range_min, null)
          net_ipv4_neigh_default_gc_thresh1  = try(sysctl_config.value.net_ipv4_neigh_default_gc_thresh1, null)
          net_ipv4_neigh_default_gc_thresh2  = try(sysctl_config.value.net_ipv4_neigh_default_gc_thresh2, null)
          net_ipv4_neigh_default_gc_thresh3  = try(sysctl_config.value.net_ipv4_neigh_default_gc_thresh3, null)
          net_ipv4_tcp_fin_timeout           = try(sysctl_config.value.net_ipv4_tcp_fin_timeout, null)
          net_ipv4_tcp_keepalive_intvl       = try(sysctl_config.value.net_ipv4_tcp_keepalive_intvl, null)
          net_ipv4_tcp_keepalive_probes      = try(sysctl_config.value.net_ipv4_tcp_keepalive_probes, null)
          net_ipv4_tcp_keepalive_time        = try(sysctl_config.value.net_ipv4_tcp_keepalive_time, null)
          net_ipv4_tcp_max_syn_backlog       = try(sysctl_config.value.net_ipv4_tcp_max_syn_backlog, null)
          net_ipv4_tcp_max_tw_buckets        = try(sysctl_config.value.net_ipv4_tcp_max_tw_buckets, null)
          net_ipv4_tcp_tw_reuse              = try(sysctl_config.value.net_ipv4_tcp_tw_reuse, null)
          net_netfilter_nf_conntrack_buckets = try(sysctl_config.value.net_netfilter_nf_conntrack_buckets, null)
          net_netfilter_nf_conntrack_max     = try(sysctl_config.value.net_netfilter_nf_conntrack_max, null)
          vm_max_map_count                   = try(sysctl_config.value.vm_max_map_count, null)
          vm_swappiness                      = try(sysctl_config.value.vm_swappiness, null)
          vm_vfs_cache_pressure              = try(sysctl_config.value.vm_vfs_cache_pressure, null)
        }
      }
      transparent_huge_page_defrag  = try(linux_os_config.value.transparent_huge_page_defrag, null)
      transparent_huge_page_enabled = try(linux_os_config.value.transparent_huge_page_enabled, null)
    }
  }

  dynamic "kubelet_config" {
    # https://github.com/hashicorp/terraform-provider-azurerm/issues/22194
    # az feature register --namespace "Microsoft.ContainerService" --name "WindowsCustomKubeletConfigPreview"
    for_each = each.value.os_type == "linux" && each.value.kubelet_config != null ? { "config" = each.value.kubelet_config } : {}

    content {
      allowed_unsafe_sysctls    = kubelet_config.value.allowed_unsafe_sysctls
      container_log_max_line    = kubelet_config.value.container_log_max_line
      container_log_max_size_mb = kubelet_config.value.container_log_max_size_mb
      cpu_cfs_quota_enabled     = kubelet_config.value.cpu_cfs_quota_enabled
      cpu_cfs_quota_period      = kubelet_config.value.cpu_cfs_quota_period
      cpu_manager_policy        = kubelet_config.value.cpu_manager_policy
      image_gc_high_threshold   = kubelet_config.value.image_gc_high_threshold
      image_gc_low_threshold    = kubelet_config.value.image_gc_low_threshold
      pod_max_pid               = kubelet_config.value.pod_max_pid
      topology_manager_policy   = kubelet_config.value.topology_manager_policy
    }
  }
}

# az feature register --namespace "Microsoft.ContainerService" --name "AKS-Dapr"
# ExtensionTypeRegistrationGetFailed Message="Extension type 'microsoft_dapr' is not supported in region.
resource "azurerm_kubernetes_cluster_extension" "ext" {
  for_each = try(var.cluster.extensions, {})

  name                             = "ext-${each.key}"
  cluster_id                       = azurerm_kubernetes_cluster.aks.id
  extension_type                   = each.key
  release_train                    = try(each.value.release_train, null)
  target_namespace                 = try(each.value.target_namespace, null)
  release_namespace                = try(each.value.release_namespace, null)
  configuration_settings           = try(each.value.configuration_settings, null)
  configuration_protected_settings = try(each.value.configuration_protected_settings, null)

  dynamic "plan" {
    for_each = try(each.value.plan, {})

    content {
      name      = plan.value.name
      publisher = plan.value.publisher
      product   = plan.value.product
    }
  }
}

# role assignment
resource "azurerm_role_assignment" "role" {
  for_each = lookup(var.cluster, "registry", null) != null ? { "default" = var.cluster.registry } : {}

  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.cluster.registry.role_assignment_scope
  skip_service_principal_aad_check = true
}
