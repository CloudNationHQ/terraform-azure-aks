data "azurerm_subscription" "current" {}

# aks cluster
resource "azurerm_kubernetes_cluster" "aks" {

  name                                = var.cluster.name
  location                            = coalesce(lookup(var.cluster, "location", null), var.location)
  resource_group_name                 = coalesce(lookup(var.cluster, "resource_group", null), var.resource_group)
  dns_prefix                          = try(var.cluster.dns_prefix, null)
  dns_prefix_private_cluster          = try(var.cluster.dns_prefix_private_cluster, null)
  automatic_upgrade_channel           = try(var.cluster.automatic_upgrade_channel, null)
  azure_policy_enabled                = try(var.cluster.azure_policy_enabled, false)
  cost_analysis_enabled               = try(var.cluster.cost_analysis_enabled, false)
  disk_encryption_set_id              = try(var.cluster.disk_encryption_set_id, null)
  edge_zone                           = try(var.cluster.edge_zone, null)
  http_application_routing_enabled    = try(var.cluster.http_application_routing_enabled, null)
  image_cleaner_enabled               = try(var.cluster.image_cleaner_enabled, null)
  image_cleaner_interval_hours        = try(var.cluster.image_cleaner_interval_hours, null)
  kubernetes_version                  = try(var.cluster.kubernetes_version, null)
  local_account_disabled              = try(var.cluster.local_account_disabled, null)
  node_os_upgrade_channel             = try(var.cluster.node_os_upgrade_channel, null)
  node_resource_group                 = try(var.cluster.node_resource_group, "${var.cluster.resource_group}-nodepool")
  oidc_issuer_enabled                 = try(var.cluster.oidc_issuer_enabled, null)
  open_service_mesh_enabled           = try(var.cluster.open_service_mesh_enabled, null)
  private_cluster_enabled             = try(var.cluster.private_cluster_enabled, false)
  private_dns_zone_id                 = try(var.cluster.private_dns_zone_id, null)
  private_cluster_public_fqdn_enabled = try(var.cluster.private_cluster_public_fqdn_enabled, false)
  workload_identity_enabled           = try(var.cluster.workload_identity_enabled, false)
  role_based_access_control_enabled   = try(var.cluster.role_based_access_control_enabled, true)
  run_command_enabled                 = try(var.cluster.run_command_enabled, true)
  sku_tier                            = try(var.cluster.sku_tier, "Free")
  support_plan                        = try(var.cluster.support_plan, "KubernetesOfficial")
  tags                                = try(var.cluster.tags, var.tags, null)

  default_node_pool {
    name                          = try(var.cluster.default_node_pool.name, "default")
    vm_size                       = try(var.cluster.default_node_pool.vm_size, "Standard_D2as_v5")
    capacity_reservation_group_id = try(var.cluster.default_node_pool.capacity_reservation_group_id, null)
    auto_scaling_enabled          = try(var.cluster.default_node_pool.auto_scaling_enabled, null)
    node_count                    = try(var.cluster.default_node_pool.auto_scaling_enabled, null) != null ? null : try(var.cluster.default_node_pool.node_count, 2)
    min_count                     = try(var.cluster.default_node_pool.min_count, null)
    max_count                     = try(var.cluster.default_node_pool.max_count, null)
    host_encryption_enabled       = try(var.cluster.default_node_pool.host_encryption_enabled, null)
    node_public_ip_enabled        = try(var.cluster.default_node_pool.node_public_ip_enabled, false)
    gpu_instance                  = try(var.cluster.default_node_pool.gpu_instance, null)
    host_group_id                 = try(var.cluster.default_node_pool.host_group_id, null)
    fips_enabled                  = try(var.cluster.default_node_pool.fips_enabled, null)
    kubelet_disk_type             = try(var.cluster.default_node_pool.kubelet_disk_type, null)
    max_pods                      = try(var.cluster.default_node_pool.max_pods, null)
    node_public_ip_prefix_id      = try(var.cluster.default_node_pool.node_public_ip_prefix_id, null)
    node_labels                   = try(var.cluster.default_node_pool.node_labels, {})
    only_critical_addons_enabled  = try(var.cluster.default_node_pool.only_critical_addons_enabled, false)
    orchestrator_version          = try(var.cluster.default_node_pool.orchestrator_version, null)
    os_disk_size_gb               = try(var.cluster.default_node_pool.os_disk_size_gb, null)
    os_disk_type                  = try(var.cluster.default_node_pool.os_disk_type, null)
    os_sku                        = try(var.cluster.default_node_pool.os_sku, null)
    pod_subnet_id                 = try(var.cluster.default_node_pool.pod_subnet_id, null)
    proximity_placement_group_id  = try(var.cluster.default_node_pool.proximity_placement_group_id, null)
    scale_down_mode               = try(var.cluster.default_node_pool.scale_down_mode, "Delete")
    snapshot_id                   = try(var.cluster.default_node_pool.snapshot_id, null)
    temporary_name_for_rotation   = try(var.cluster.default_node_pool.temporary_name_for_rotation, null)
    type                          = try(var.cluster.default_node_pool.type, "VirtualMachineScaleSets")
    tags                          = try(var.cluster.default_node_pool.tags, var.tags, null)
    ultra_ssd_enabled             = try(var.cluster.default_node_pool.ultra_ssd_enabled, false)
    vnet_subnet_id                = try(var.cluster.default_node_pool.vnet_subnet_id, null)
    workload_runtime              = try(var.cluster.default_node_pool.workload_runtime, null)
    zones                         = try(var.cluster.default_node_pool.zones, [1, 2, 3])

    dynamic "kubelet_config" {
      for_each = (
        lookup(lookup(var.cluster, "default_node_pool", {}), "kubelet_config", null) != null
        ? { "default" = lookup(lookup(var.cluster, "default_node_pool", {}), "kubelet_config", null) }
        : {}
      )

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

    dynamic "linux_os_config" {
      for_each = (
        lookup(lookup(var.cluster, "default_node_pool", {}), "linux_os_config", null) != null
        ? { "default" = lookup(lookup(var.cluster, "default_node_pool", {}), "linux_os_config", null) }
        : {}
      )

      content {
        swap_file_size_mb = try(linux_os_config.value.swap_file_size_mb, null)
        dynamic "sysctl_config" {
          for_each = lookup(linux_os_config.value, "sysctl_config", null) != null ? { "default" = linux_os_config.value.sysctl_config } : {}

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

    dynamic "node_network_profile" {
      for_each = (
        lookup(lookup(var.cluster, "default_node_pool", {}), "node_network_profile", null) != null
        ? { "default" = lookup(lookup(var.cluster, "default_node_pool", {}), "node_network_profile", null) }
        : {}
      )

      content {
        dynamic "allowed_host_ports" {
          for_each = lookup(node_network_profile.value, "allowed_host_ports", null) != null ? { "default" = lookup(node_network_profile.value, "allowed_host_ports", null) } : {}

          content {
            port_start = try(allowed_host_ports.value.port_start, null)
            port_end   = try(allowed_host_ports.value.port_end, null)
            protocol   = try(allowed_host_ports.value.protocol, null)
          }
        }
        application_security_group_ids = try(node_network_profile.value.application_security_group_ids, [])
        node_public_ip_tags            = try(node_network_profile.value.node_public_ip_tags, null)
      }
    }

    dynamic "upgrade_settings" {
      for_each = (
        lookup(lookup(var.cluster, "default_node_pool", {}), "upgrade_settings", null) != null
        ? { "default" = lookup(lookup(var.cluster, "default_node_pool", {}), "upgrade_settings", null) }
        : {}
      )

      content {
        max_surge                     = upgrade_settings.value.max_surge
        drain_timeout_in_minutes      = try(upgrade_settings.value.drain_timeout_in_minutes, null)
        node_soak_duration_in_minutes = try(upgrade_settings.value.node_soak_duration_in_minutes, null)
      }
    }
  }

  dynamic "aci_connector_linux" {
    for_each = lookup(var.cluster.default_node_pool, "aci_connector_linux", null) != null ? { "default" = var.cluster.default_node_pool.aci_connector_linux } : {}
    content {
      subnet_name = aci_connector_linux.value.subnet_name
    }
  }

  dynamic "api_server_access_profile" {
    for_each = lookup(var.cluster, "api_server_access_profile", null) != null ? { "default" = var.cluster.api_server_access_profile } : {}
    content {
      authorized_ip_ranges = api_server_access_profile.value.authorized_ip_ranges
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = lookup(var.cluster, "auto_scaler_profile", null) != null ? { "default" = var.cluster.auto_scaler_profile } : {}

    content {
      balance_similar_node_groups      = try(auto_scaler_profile.value.balance_similar_node_groups, false)
      expander                         = try(auto_scaler_profile.value.expander, "random")
      max_graceful_termination_sec     = try(auto_scaler_profile.value.max_graceful_termination_sec, "600")
      max_node_provisioning_time       = try(auto_scaler_profile.value.max_node_provisioning_time, "15m")
      max_unready_nodes                = try(auto_scaler_profile.value.max_unready_nodes, "3")
      max_unready_percentage           = try(auto_scaler_profile.value.max_unready_percentage, "45")
      new_pod_scale_up_delay           = try(auto_scaler_profile.value.new_pod_scale_up_delay, "10s")
      scale_down_delay_after_add       = try(auto_scaler_profile.value.scale_down_delay_after_add, "10m")
      scale_down_delay_after_delete    = try(auto_scaler_profile.value.scale_down_delay_after_delete, "10s")
      scale_down_delay_after_failure   = try(auto_scaler_profile.value.scale_down_delay_after_failure, "3m")
      scan_interval                    = try(auto_scaler_profile.value.scan_interval, "10s")
      scale_down_unneeded              = try(auto_scaler_profile.value.scale_down_unneeded, "10m")
      scale_down_unready               = try(auto_scaler_profile.value.scale_down_unready, "20m")
      scale_down_utilization_threshold = try(auto_scaler_profile.value.scale_down_utilization_threshold, "0.5")
      empty_bulk_delete_max            = try(auto_scaler_profile.value.empty_bulk_delete_max, "10")
      skip_nodes_with_local_storage    = try(auto_scaler_profile.value.skip_nodes_with_local_storage, true)
      skip_nodes_with_system_pods      = try(auto_scaler_profile.value.skip_nodes_with_system_pods, true)
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = lookup(var.cluster, "azure_active_directory_role_based_access_control", null) != null ? { "default" = var.cluster.azure_active_directory_role_based_access_control } : {}
    content {
      tenant_id              = try(azure_active_directory_role_based_access_control.value.tenant_id, data.azurerm_subscription.current.tenant_id, null)
      admin_group_object_ids = try(azure_active_directory_role_based_access_control.value.admin_group_object_ids, null)
      azure_rbac_enabled     = try(azure_active_directory_role_based_access_control.value.azure_rbac_enabled, true)
    }
  }

  dynamic "confidential_computing" {
    for_each = lookup(var.cluster, "confidential_computing", null) != null ? { "default" = var.cluster.confidential_computing } : {}
    content {
      sgx_quote_helper_enabled = confidential_computing.value.sgx_quote_helper_enabled
    }
  }

  dynamic "http_proxy_config" {
    for_each = lookup(var.cluster, "http_proxy_config", null) != null ? { "default" = var.cluster.http_proxy_config } : {}

    content {
      http_proxy  = try(http_proxy_config.value.http, null)
      https_proxy = try(http_proxy_config.value.https, null)
      no_proxy    = try(http_proxy_config.value.exceptions, [])
      trusted_ca  = try(http_proxy_config.value.trusted_ca, null)
    }
  }

  identity {
    type = var.cluster.identity.type
    identity_ids = var.cluster.identity.type == "UserAssigned" ? (
      length(lookup(var.cluster.identity, "identity_ids", [])) > 0 ? var.cluster.identity.identity_ids :
      [for identity in azurerm_user_assigned_identity.cluster_identity : identity.id]
    ) : null
  }

  dynamic "ingress_application_gateway" {
    for_each = lookup(var.cluster, "ingress_application_gateway", null) != null ? { "default" = var.cluster.ingress_application_gateway } : {}

    content {
      gateway_id   = try(ingress_application_gateway.value.gateway_id, null)
      gateway_name = try(ingress_application_gateway.value.gateway_name, null)
      subnet_cidr  = try(ingress_application_gateway.value.subnet_cidr, null)
      subnet_id    = try(ingress_application_gateway.value.subnet_id, null)
    }
  }

  dynamic "key_management_service" {
    for_each = lookup(var.cluster, "key_management_service", null) != null ? { "default" = var.cluster.key_management_service } : {}
    content {
      key_vault_key_id         = key_management_service.value.key_vault_key_id
      key_vault_network_access = try(key_management_service.value.key_vault_network_access, "Public")
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = lookup(var.cluster, "key_vault_secrets_provider", null) != null ? { "default" = var.cluster.key_vault_secrets_provider } : {}

    content {
      secret_rotation_enabled  = try(key_vault_secrets_provider.value.secret_rotation_enabled, false)
      secret_rotation_interval = try(key_vault_secrets_provider.value.secret_rotation_interval, "2m")
    }
  }

  dynamic "kubelet_identity" {
    for_each = lookup(var.cluster, "kubelet_identity", null) != null ? [var.cluster.kubelet_identity] : []
    content {
      user_assigned_identity_id = kubelet_identity.value.user_assigned_identity_id
      client_id                 = kubelet_identity.value.client_id
      object_id                 = kubelet_identity.value.object_id
    }
  }

  dynamic "linux_profile" {
    for_each = lookup(var.cluster, "linux_profile", null) != null ? { "default" = var.cluster.linux_profile } : {}
    content {
      admin_username = try(var.cluster.username, linux_profile.value.admin_username, "nodeadmin")
      ssh_key {
        key_data = try(var.cluster.public_key, linux_profile.value.ssh_key.key_data, null) != null ? try(var.cluster.public_key, linux_profile.value.ssh_key.key_data) : tls_private_key.tls_key["default"].public_key_openssh
      }
    }
  }

  dynamic "maintenance_window" {
    for_each = lookup(var.cluster, "maintenance_window", null) != null ? { "default" = var.cluster.maintenance_window } : {}

    content {
      dynamic "allowed" {
        for_each = {
          for k, v in try(var.cluster.maintenance_window.allowed, {}) : k => v
        }
        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }
      dynamic "not_allowed" {
        for_each = {
          for k, v in try(var.cluster.maintenance_window.not_allowed, {}) : k => v
        }
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  dynamic "maintenance_window_auto_upgrade" {
    for_each = lookup(var.cluster, "maintenance_window_auto_upgrade", null) != null ? { "default" = var.cluster.maintenance_window_auto_upgrade } : {}

    content {
      dynamic "not_allowed" {
        for_each = {
          for k, v in try(var.cluster.maintenance_window_auto_upgrade.not_allowed, {}) : k => v
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

  dynamic "maintenance_window_node_os" {
    for_each = lookup(var.cluster, "maintenance_window_node_os", null) != null ? { "default" = var.cluster.maintenance_window_node_os } : {}

    content {
      dynamic "not_allowed" {
        for_each = {
          for k, v in try(var.cluster.maintenance_window_node_os.not_allowed, {}) : k => v
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

  dynamic "microsoft_defender" {
    for_each = lookup(var.cluster, "microsoft_defender", null) != null ? { "default" = var.cluster.microsoft_defender } : {}

    content {
      log_analytics_workspace_id = try(microsoft_defender.value.log_analytics_workspace_id, null)
    }
  }

  dynamic "monitor_metrics" {
    for_each = lookup(var.cluster, "monitor_metrics", null) != null ? { "default" = var.cluster.monitor_metrics } : {}

    content {
      annotations_allowed = try(monitor_metrics.value.annotations_allowed, null)
      labels_allowed      = try(monitor_metrics.value.labels_allowed, null)
    }
  }

  dynamic "network_profile" {
    for_each = lookup(var.cluster, "network_profile", null) != null ? { "default" = var.cluster.network_profile } : {}

    content {
      network_plugin      = try(network_profile.value.network_plugin, "azure")
      network_mode        = try(network_profile.value.network_mode, null)
      network_policy      = try(network_profile.value.network_policy, null)
      dns_service_ip      = try(network_profile.value.dns_service_ip, null)
      outbound_type       = try(network_profile.value.outbound_type, null)
      pod_cidr            = try(network_profile.value.pod_cidr, null)
      service_cidr        = try(network_profile.value.service_cidr, null)
      load_balancer_sku   = try(network_profile.value.load_balancer_sku, "standard")
      pod_cidrs           = try(network_profile.value.pod_cidrs, null)
      ip_versions         = try(network_profile.value.ip_versions, null)
      network_data_plane  = try(network_profile.value.network_data_plane, null)
      service_cidrs       = try(network_profile.value.service_cidrs, null)
      network_plugin_mode = try(network_profile.value.network_plugin_mode, "overlay")

      dynamic "load_balancer_profile" {
        for_each = lookup(network_profile.value, "load_balancer_profile", null) != null ? { "default" = lookup(network_profile.value, "load_balancer_profile", null) } : {}

        content {
          managed_outbound_ip_count   = try(load_balancer_profile.value.managed_outbound_ip_count, null)
          outbound_ip_prefix_ids      = try(load_balancer_profile.value.outbound_ip_prefix_ids, null)
          outbound_ip_address_ids     = try(load_balancer_profile.value.outbound_ip_address_ids, null)
          outbound_ports_allocated    = try(load_balancer_profile.value.outbound_ports_allocated, null)
          idle_timeout_in_minutes     = try(load_balancer_profile.value.idle_timeout_in_minutes, null)
          managed_outbound_ipv6_count = try(load_balancer_profile.value.managed_outbound_ipv6_count, null)
        }
      }

      dynamic "nat_gateway_profile" {
        for_each = lookup(network_profile.value, "nat_gateway_profile", null) != null ? { "default" = lookup(network_profile.value, "nat_gateway_profile", null) } : {}

        content {
          idle_timeout_in_minutes   = try(nat_gateway_profile.value.idle_timeout_in_minutes, "4")
          managed_outbound_ip_count = try(nat_gateway_profile.value.managed_outbound_ip_count, null)
        }
      }
    }
  }

  dynamic "oms_agent" {
    for_each = lookup(var.cluster, "oms_agent", null) != null ? { "default" = var.cluster.oms_agent } : {}

    content {
      log_analytics_workspace_id      = try(oms_agent.value.log_analytics_workspace_id, null)
      msi_auth_for_monitoring_enabled = try(oms_agent.value.enable.msi_auth_for_monitoring, false)
    }
  }

  dynamic "service_mesh_profile" {
    for_each = lookup(var.cluster, "service_mesh_profile", null) != null ? { "default" = var.cluster.service_mesh_profile } : {}

    content {
      revisions                        = try(service_mesh_profile.value.revisions, null)
      mode                             = try(service_mesh_profile.value.mode, false)
      internal_ingress_gateway_enabled = try(service_mesh_profile.value.internal_ingress_gateway_enabled, false)
      external_ingress_gateway_enabled = try(service_mesh_profile.value.external_ingress_gateway_enabled, false)
    }
  }

  dynamic "workload_autoscaler_profile" {
    for_each = lookup(var.cluster, "workload_autoscaler_profile", null) != null ? { default = var.cluster.workload_autoscaler_profile } : {}

    content {
      # https://learn.microsoft.com/en-gb/azure/aks/keda-deploy-add-on-arm#register-the-aks-kedapreview-feature-flag
      # https://learn.microsoft.com/en-us/azure/aks/vertical-pod-autoscaler#register-the-aks-vpapreview-feature-flag

      keda_enabled                    = try(workload_autoscaler_profile.value.keda_enabled, null)
      vertical_pod_autoscaler_enabled = try(workload_autoscaler_profile.value.vertical_pod_autoscaler_enabled, null)
    }
  }

  dynamic "storage_profile" {
    for_each = lookup(var.cluster, "storage_profile", null) != null ? { "default" = var.cluster.storage_profile } : {}

    content {
      blob_driver_enabled         = try(storage_profile.value.blob_driver_enabled, false)
      disk_driver_enabled         = try(storage_profile.value.disk_driver_enabled, true)
      file_driver_enabled         = try(storage_profile.value.file_driver_enabled, true)
      snapshot_controller_enabled = try(storage_profile.value.snapshot_controller_enabled, true)
    }
  }

  dynamic "web_app_routing" {
    for_each = lookup(var.cluster, "web_app_routing", null) != null ? { "default" = var.cluster.web_app_routing } : {}
    content {
      dns_zone_ids = web_app_routing.value.dns_zone_ids
    }
  }

  dynamic "windows_profile" {
    for_each = lookup(var.cluster, "windows_profile", null) != null ? { "default" = var.cluster.windows_profile } : {}
    content {
      admin_username = try(var.cluster.username, windows_profile.value.admin_username, "nodeadmin")
      admin_password = try(var.cluster.password, windows_profile.value.admin_username, null) != null ? try(var.cluster.password, windows_profile.value.admin_username) : azurerm_key_vault_secret.secret["default"].value
      license        = try(windows_profile.value.license, null)
      dynamic "gmsa" {
        for_each = lookup(windows_profile.value, "gmsa", null) != null ? { "default" = lookup(windows_profile.value, "gmsa", null) } : {}
        content {
          dns_server  = gmsa.value.dns_server
          root_domain = gmsa.value.root_domain
        }
      }
    }
  }
}

# secrets
resource "tls_private_key" "tls_key" {
  for_each = var.cluster.profile == "linux" && lookup(var.cluster, "public_key", {}) == {} ? {
    "default" = var.cluster.name
  } : {}

  algorithm = try(var.cluster.encryption.algorithm, "RSA")
  rsa_bits  = try(var.cluster.encryption.rsa_bits, 4096)
}

resource "azurerm_key_vault_secret" "tls_public_key_secret" {
  for_each = var.cluster.profile == "linux" && lookup(var.cluster, "public_key", {}) == {} ? {
    "default" = var.cluster.name
  } : {}

  name         = format("%s-%s-%s", "kvs", var.cluster.name, "pub")
  value        = tls_private_key.tls_key[each.key].public_key_openssh
  key_vault_id = var.keyvault
}

resource "azurerm_key_vault_secret" "tls_private_key_secret" {
  for_each = var.cluster.profile == "linux" && lookup(var.cluster, "public_key", {}) == {} ? {
    "default" = var.cluster.name
  } : {}

  name         = format("%s-%s-%s", "kvs", var.cluster.name, "prv")
  value        = tls_private_key.tls_key[each.key].private_key_pem
  key_vault_id = var.keyvault
}

# random password
resource "random_password" "password" {
  for_each = var.cluster.profile == "windows" && lookup(var.cluster, "password", {}) == {} ? {
    "default" = var.cluster.name
  } : {}

  length      = 24
  special     = true
  min_lower   = 5
  min_upper   = 7
  min_special = 4
  min_numeric = 5
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = var.cluster.profile == "windows" && lookup(var.cluster, "password", {}) == {} ? {
    "default" = var.cluster.name
  } : {}

  name         = format("%s-%s", "kvs", var.cluster.name)
  value        = random_password.password[each.key].result
  key_vault_id = var.keyvault
}

# node pools
resource "azurerm_kubernetes_cluster_node_pool" "pools" {
  for_each = {
    for pools_key, pools in lookup(var.cluster, "node_pools", {}) : pools_key => pools
  }

  name                          = try(each.value.name, each.value.os_type == "Linux" ? "npl${each.key}" : "npw${each.key}")
  kubernetes_cluster_id         = azurerm_kubernetes_cluster.aks.id
  vm_size                       = try(each.value.vm_size, "Standard_D2as_v5")
  node_count                    = try(each.value.node_count, 1)
  max_count                     = try(each.value.max_count, 0)
  min_count                     = try(each.value.min_count, 0)
  zones                         = try(each.value.zones, null)
  auto_scaling_enabled          = try(each.value.auto_scaling_enabled, false)
  host_encryption_enabled       = try(each.value.host_encryption_enabled, false)
  node_public_ip_enabled        = try(each.value.node_public_ip_enabled, false)
  fips_enabled                  = try(each.value.enable.fips, false)
  eviction_policy               = try(each.value.eviction_policy, null)
  kubelet_disk_type             = try(each.value.kubelet_disk_type, null)
  os_disk_size_gb               = try(each.value.os_disk_size_gb, null)
  os_disk_type                  = try(each.value.os_disk_type, null)
  orchestrator_version          = try(each.value.orchestrator_version, null)
  ultra_ssd_enabled             = try(each.value.ultra_ssd_enabled, false)
  host_group_id                 = try(each.value.host_group_id, null)
  pod_subnet_id                 = try(each.value.pod_subnet_id, null)
  spot_max_price                = try(each.value.spot_max_price, null)
  scale_down_mode               = try(each.value.scale_down_mode, null)
  node_public_ip_prefix_id      = try(each.value.node_public_ip_prefix_id, null)
  proximity_placement_group_id  = try(each.value.proximity_placement_group_id, null)
  capacity_reservation_group_id = try(each.value.capacity_reservation_group_id, null)
  max_pods                      = try(each.value.max_pods, 30)
  mode                          = try(each.value.mode, "User")
  node_labels                   = try(each.value.node_labels, {})
  node_taints                   = try(each.value.node_taints, [])
  os_sku                        = try(each.value.os_sku, null)
  os_type                       = try(each.value.os_type, "Linux")
  priority                      = try(each.value.priority, null)
  snapshot_id                   = try(each.value.snapshot_id, null)
  workload_runtime              = try(each.value.workload_runtime, null)
  vnet_subnet_id                = try(each.value.vnet_subnet_id, null)
  tags                          = try(each.value.tags, var.cluster.tags, null)


  dynamic "upgrade_settings" {
    for_each = try(each.value.upgrade_settings, null) != null ? [each.value.upgrade_settings] : []

    content {
      max_surge                     = upgrade_settings.value.max_surge
      drain_timeout_in_minutes      = try(upgrade_settings.value.drain_timeout_in_minutes, null)
      node_soak_duration_in_minutes = try(upgrade_settings.value.node_soak_duration_in_minutes, null)
    }
  }

  dynamic "linux_os_config" {
    for_each = try(each.value.os_type, "Linux") == "Linux" && try(each.value.linux_os_config, null) != null ? [each.value.linux_os_config] : []

    content {
      swap_file_size_mb             = try(linux_os_config.value.swap_file_size_mb, null)
      transparent_huge_page_defrag  = try(linux_os_config.value.transparent_huge_page_defrag, "madvise")
      transparent_huge_page_enabled = try(linux_os_config.value.transparent_huge_page_enabled, "always")

      dynamic "sysctl_config" {
        for_each = try(linux_os_config.value.sysctl_config, null) != null ? [linux_os_config.value.sysctl_config] : []
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
          net_ipv4_ip_local_port_range_min   = try(sysctl_config.value.net_ipv4_ip_local_port_range_min, null)
          net_ipv4_ip_local_port_range_max   = try(sysctl_config.value.net_ipv4_ip_local_port_range_max, null)
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
    }
  }

  dynamic "kubelet_config" {
    for_each = try(each.value.os_type, "Linux") == "Linux" && try(each.value.kubelet_config, null) != null ? [each.value.kubelet_config] : []

    content {
      allowed_unsafe_sysctls    = try(kubelet_config.value.allowed_unsafe_sysctls, null)
      container_log_max_line    = try(kubelet_config.value.container_log_max_line, null)
      container_log_max_size_mb = try(kubelet_config.value.container_log_max_size_mb, null)
      cpu_cfs_quota_enabled     = try(kubelet_config.value.cpu_cfs_quota_enabled, null)
      cpu_cfs_quota_period      = try(kubelet_config.value.cpu_cfs_quota_period, null)
      cpu_manager_policy        = try(kubelet_config.value.cpu_manager_policy, null)
      image_gc_high_threshold   = try(kubelet_config.value.image_gc_high_threshold, null)
      image_gc_low_threshold    = try(kubelet_config.value.image_gc_low_threshold, null)
      pod_max_pid               = try(kubelet_config.value.pod_max_pid, null)
      topology_manager_policy   = try(kubelet_config.value.topology_manager_policy, null)
    }
  }

  dynamic "windows_profile" {
    for_each = try(each.value.os_type, "Linux") == "Windows" && try(each.value.windows_profile, null) != null ? [each.value.windows_profile] : []

    content {
      outbound_nat_enabled = try(windows_profile.value.outbound_nat_enabled, true)
    }
  }
}

# az feature register --namespace "Microsoft.ContainerService" --name "AKS-Dapr"
# ExtensionTypeRegistrationGetFailed Message="Extension type 'microsoft_dapr' is not supported in region.
resource "azurerm_kubernetes_cluster_extension" "ext" {
  for_each = try(
    var.cluster.extensions, {}
  )

  name                             = "ext-${each.key}"
  cluster_id                       = azurerm_kubernetes_cluster.aks.id
  extension_type                   = each.value.extension_type
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
  skip_service_principal_aad_check = try(var.cluster.registry.skip_service_principal_aad_check, false)
}

# user assigned identity
resource "azurerm_user_assigned_identity" "cluster_identity" {
  for_each = var.cluster.identity.type == "UserAssigned" && length(lookup(var.cluster.identity, "identity_ids", [])) == 0 ? { "cluster" = true } : {}

  name                = "uai-${var.cluster.name}-cluster"
  resource_group_name = var.cluster.resource_group
  location            = var.cluster.location
  tags                = try(var.cluster.tags, null)
}
