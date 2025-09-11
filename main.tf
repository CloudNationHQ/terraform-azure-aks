data "azurerm_subscription" "current" {}

# aks cluster
resource "azurerm_kubernetes_cluster" "aks" {
  resource_group_name = coalesce(
    lookup(
      var.cluster, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(
      var.cluster, "location", null
    ), var.location
  )

  name                                = var.cluster.name
  dns_prefix                          = var.cluster.dns_prefix
  dns_prefix_private_cluster          = var.cluster.dns_prefix_private_cluster
  automatic_upgrade_channel           = var.cluster.automatic_upgrade_channel
  azure_policy_enabled                = var.cluster.azure_policy_enabled
  cost_analysis_enabled               = var.cluster.cost_analysis_enabled
  disk_encryption_set_id              = var.cluster.disk_encryption_set_id
  edge_zone                           = var.cluster.edge_zone
  http_application_routing_enabled    = var.cluster.http_application_routing_enabled
  image_cleaner_enabled               = var.cluster.image_cleaner_enabled
  image_cleaner_interval_hours        = var.cluster.image_cleaner_interval_hours
  kubernetes_version                  = var.cluster.kubernetes_version
  local_account_disabled              = var.cluster.local_account_disabled
  node_os_upgrade_channel             = var.cluster.node_os_upgrade_channel
  node_resource_group                 = var.cluster.node_resource_group != null ? var.cluster.node_resource_group : "${coalesce(var.cluster.resource_group_name, var.resource_group_name)}-nodepool"
  oidc_issuer_enabled                 = var.cluster.oidc_issuer_enabled
  open_service_mesh_enabled           = var.cluster.open_service_mesh_enabled
  private_cluster_enabled             = var.cluster.private_cluster_enabled
  private_dns_zone_id                 = var.cluster.private_dns_zone_id
  private_cluster_public_fqdn_enabled = var.cluster.private_cluster_public_fqdn_enabled
  workload_identity_enabled           = var.cluster.workload_identity_enabled
  role_based_access_control_enabled   = var.cluster.role_based_access_control_enabled
  run_command_enabled                 = var.cluster.run_command_enabled
  sku_tier                            = var.cluster.sku_tier
  support_plan                        = var.cluster.support_plan
  custom_ca_trust_certificates_base64 = var.cluster.custom_ca_trust_certificates_base64

  tags = coalesce(
    var.cluster.tags, var.tags
  )

  dynamic "service_principal" {
    for_each = try(var.cluster.service_principal, null) != null ? { "default" = var.cluster.service_principal } : {}

    content {
      client_id     = service_principal.value.client_id
      client_secret = service_principal.value.client_secret
    }
  }

  default_node_pool {
    name                          = var.cluster.default_node_pool.name
    vm_size                       = var.cluster.default_node_pool.vm_size
    capacity_reservation_group_id = var.cluster.default_node_pool.capacity_reservation_group_id
    auto_scaling_enabled          = var.cluster.default_node_pool.auto_scaling_enabled
    node_count                    = var.cluster.default_node_pool.auto_scaling_enabled != null ? null : var.cluster.default_node_pool.node_count
    min_count                     = var.cluster.default_node_pool.min_count
    max_count                     = var.cluster.default_node_pool.max_count
    host_encryption_enabled       = var.cluster.default_node_pool.host_encryption_enabled
    node_public_ip_enabled        = var.cluster.default_node_pool.node_public_ip_enabled
    gpu_instance                  = var.cluster.default_node_pool.gpu_instance
    host_group_id                 = var.cluster.default_node_pool.host_group_id
    fips_enabled                  = var.cluster.default_node_pool.fips_enabled
    kubelet_disk_type             = var.cluster.default_node_pool.kubelet_disk_type
    max_pods                      = var.cluster.default_node_pool.max_pods
    node_public_ip_prefix_id      = var.cluster.default_node_pool.node_public_ip_prefix_id
    node_labels                   = var.cluster.default_node_pool.node_labels
    only_critical_addons_enabled  = var.cluster.default_node_pool.only_critical_addons_enabled
    orchestrator_version          = var.cluster.default_node_pool.orchestrator_version
    os_disk_size_gb               = var.cluster.default_node_pool.os_disk_size_gb
    os_disk_type                  = var.cluster.default_node_pool.os_disk_type
    os_sku                        = var.cluster.default_node_pool.os_sku
    pod_subnet_id                 = var.cluster.default_node_pool.pod_subnet_id
    proximity_placement_group_id  = var.cluster.default_node_pool.proximity_placement_group_id
    scale_down_mode               = var.cluster.default_node_pool.scale_down_mode
    snapshot_id                   = var.cluster.default_node_pool.snapshot_id
    temporary_name_for_rotation   = var.cluster.default_node_pool.temporary_name_for_rotation
    type                          = var.cluster.default_node_pool.type
    ultra_ssd_enabled             = var.cluster.default_node_pool.ultra_ssd_enabled
    vnet_subnet_id                = var.cluster.default_node_pool.vnet_subnet_id
    workload_runtime              = var.cluster.default_node_pool.workload_runtime
    zones                         = var.cluster.default_node_pool.zones

    tags = coalesce(
      var.cluster.default_node_pool.tags, var.tags
    )

    dynamic "kubelet_config" {
      for_each = (
        try(var.cluster.default_node_pool.kubelet_config, null) != null
        ? { "default" = var.cluster.default_node_pool.kubelet_config }
        : {}
      )

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

    dynamic "linux_os_config" {
      for_each = (
        try(var.cluster.default_node_pool.linux_os_config, null) != null
        ? { "default" = var.cluster.default_node_pool.linux_os_config }
        : {}
      )

      content {
        swap_file_size_mb     = linux_os_config.value.swap_file_size_mb
        transparent_huge_page = linux_os_config.value.transparent_huge_page

        dynamic "sysctl_config" {
          for_each = try(linux_os_config.value.sysctl_config, null) != null ? { "default" = linux_os_config.value.sysctl_config } : {}

          content {
            fs_aio_max_nr                      = sysctl_config.value.fs_aio_max_nr
            fs_file_max                        = sysctl_config.value.fs_file_max
            fs_inotify_max_user_watches        = sysctl_config.value.fs_inotify_max_user_watches
            fs_nr_open                         = sysctl_config.value.fs_nr_open
            kernel_threads_max                 = sysctl_config.value.kernel_threads_max
            net_core_netdev_max_backlog        = sysctl_config.value.net_core_netdev_max_backlog
            net_core_optmem_max                = sysctl_config.value.net_core_optmem_max
            net_core_rmem_default              = sysctl_config.value.net_core_rmem_default
            net_core_rmem_max                  = sysctl_config.value.net_core_rmem_max
            net_core_somaxconn                 = sysctl_config.value.net_core_somaxconn
            net_core_wmem_default              = sysctl_config.value.net_core_wmem_default
            net_core_wmem_max                  = sysctl_config.value.net_core_wmem_max
            net_ipv4_ip_local_port_range_max   = sysctl_config.value.net_ipv4_ip_local_port_range_max
            net_ipv4_ip_local_port_range_min   = sysctl_config.value.net_ipv4_ip_local_port_range_min
            net_ipv4_neigh_default_gc_thresh1  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh1
            net_ipv4_neigh_default_gc_thresh2  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh2
            net_ipv4_neigh_default_gc_thresh3  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh3
            net_ipv4_tcp_fin_timeout           = sysctl_config.value.net_ipv4_tcp_fin_timeout
            net_ipv4_tcp_keepalive_intvl       = sysctl_config.value.net_ipv4_tcp_keepalive_intvl
            net_ipv4_tcp_keepalive_probes      = sysctl_config.value.net_ipv4_tcp_keepalive_probes
            net_ipv4_tcp_keepalive_time        = sysctl_config.value.net_ipv4_tcp_keepalive_time
            net_ipv4_tcp_max_syn_backlog       = sysctl_config.value.net_ipv4_tcp_max_syn_backlog
            net_ipv4_tcp_max_tw_buckets        = sysctl_config.value.net_ipv4_tcp_max_tw_buckets
            net_ipv4_tcp_tw_reuse              = sysctl_config.value.net_ipv4_tcp_tw_reuse
            net_netfilter_nf_conntrack_buckets = sysctl_config.value.net_netfilter_nf_conntrack_buckets
            net_netfilter_nf_conntrack_max     = sysctl_config.value.net_netfilter_nf_conntrack_max
            vm_max_map_count                   = sysctl_config.value.vm_max_map_count
            vm_swappiness                      = sysctl_config.value.vm_swappiness
            vm_vfs_cache_pressure              = sysctl_config.value.vm_vfs_cache_pressure
          }
        }
        transparent_huge_page_defrag = linux_os_config.value.transparent_huge_page_defrag
      }
    }

    dynamic "node_network_profile" {
      for_each = (
        try(var.cluster.default_node_pool.node_network_profile, null) != null
        ? { "default" = var.cluster.default_node_pool.node_network_profile }
        : {}
      )

      content {
        dynamic "allowed_host_ports" {
          for_each = try(node_network_profile.value.allowed_host_ports, null) != null ? { "default" = node_network_profile.value.allowed_host_ports } : {}

          content {
            port_start = allowed_host_ports.value.port_start
            port_end   = allowed_host_ports.value.port_end
            protocol   = allowed_host_ports.value.protocol
          }
        }
        application_security_group_ids = node_network_profile.value.application_security_group_ids
        node_public_ip_tags            = node_network_profile.value.node_public_ip_tags
      }
    }

    dynamic "upgrade_settings" {
      for_each = (
        try(var.cluster.default_node_pool.upgrade_settings, null) != null
        ? { "default" = var.cluster.default_node_pool.upgrade_settings }
        : {}
      )

      content {
        max_surge                     = upgrade_settings.value.max_surge
        drain_timeout_in_minutes      = upgrade_settings.value.drain_timeout_in_minutes
        node_soak_duration_in_minutes = upgrade_settings.value.node_soak_duration_in_minutes
      }
    }
  }

  dynamic "aci_connector_linux" {
    for_each = try(var.cluster.default_node_pool.aci_connector_linux, null) != null ? { "default" = var.cluster.default_node_pool.aci_connector_linux } : {}
    content {
      subnet_name = aci_connector_linux.value.subnet_name
    }
  }

  dynamic "api_server_access_profile" {
    for_each = try(var.cluster.api_server_access_profile, null) != null ? { "default" = var.cluster.api_server_access_profile } : {}
    content {
      authorized_ip_ranges = api_server_access_profile.value.authorized_ip_ranges
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = try(var.cluster.auto_scaler_profile, null) != null ? { "default" = var.cluster.auto_scaler_profile } : {}

    content {
      balance_similar_node_groups                   = auto_scaler_profile.value.balance_similar_node_groups
      expander                                      = auto_scaler_profile.value.expander
      daemonset_eviction_for_empty_nodes_enabled    = auto_scaler_profile.value.daemonset_eviction_for_empty_nodes_enabled
      daemonset_eviction_for_occupied_nodes_enabled = auto_scaler_profile.value.daemonset_eviction_for_occupied_nodes_enabled
      ignore_daemonsets_utilization_enabled         = auto_scaler_profile.value.ignore_daemonsets_utilization_enabled
      max_graceful_termination_sec                  = auto_scaler_profile.value.max_graceful_termination_sec
      max_node_provisioning_time                    = auto_scaler_profile.value.max_node_provisioning_time
      max_unready_nodes                             = auto_scaler_profile.value.max_unready_nodes
      max_unready_percentage                        = auto_scaler_profile.value.max_unready_percentage
      new_pod_scale_up_delay                        = auto_scaler_profile.value.new_pod_scale_up_delay
      scale_down_delay_after_add                    = auto_scaler_profile.value.scale_down_delay_after_add
      scale_down_delay_after_delete                 = auto_scaler_profile.value.scale_down_delay_after_delete
      scale_down_delay_after_failure                = auto_scaler_profile.value.scale_down_delay_after_failure
      scan_interval                                 = auto_scaler_profile.value.scan_interval
      scale_down_unneeded                           = auto_scaler_profile.value.scale_down_unneeded
      scale_down_unready                            = auto_scaler_profile.value.scale_down_unready
      scale_down_utilization_threshold              = auto_scaler_profile.value.scale_down_utilization_threshold
      empty_bulk_delete_max                         = auto_scaler_profile.value.empty_bulk_delete_max
      skip_nodes_with_local_storage                 = auto_scaler_profile.value.skip_nodes_with_local_storage
      skip_nodes_with_system_pods                   = auto_scaler_profile.value.skip_nodes_with_system_pods
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = try(var.cluster.azure_active_directory_role_based_access_control, null) != null ? { "default" = var.cluster.azure_active_directory_role_based_access_control } : {}

    content {
      tenant_id = coalesce(
        azure_active_directory_role_based_access_control.value.tenant_id, data.azurerm_subscription.current.tenant_id
      )

      admin_group_object_ids = azure_active_directory_role_based_access_control.value.admin_group_object_ids
      azure_rbac_enabled     = azure_active_directory_role_based_access_control.value.azure_rbac_enabled
    }
  }

  dynamic "confidential_computing" {
    for_each = try(var.cluster.confidential_computing, null) != null ? { "default" = var.cluster.confidential_computing } : {}

    content {
      sgx_quote_helper_enabled = confidential_computing.value.sgx_quote_helper_enabled
    }
  }

  dynamic "http_proxy_config" {
    for_each = try(var.cluster.http_proxy_config, null) != null ? { "default" = var.cluster.http_proxy_config } : {}

    content {
      http_proxy  = http_proxy_config.value.http
      https_proxy = http_proxy_config.value.https
      no_proxy    = http_proxy_config.value.exceptions
      trusted_ca  = http_proxy_config.value.trusted_ca
    }
  }

  dynamic "identity" {
    for_each = var.cluster.identity != null ? [var.cluster.identity] : var.cluster.service_principal == null ? [{
      type = "SystemAssigned"
    }] : []

    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = try(var.cluster.ingress_application_gateway, null) != null ? { "default" = var.cluster.ingress_application_gateway } : {}

    content {
      gateway_id   = ingress_application_gateway.value.gateway_id
      gateway_name = ingress_application_gateway.value.gateway_name
      subnet_cidr  = ingress_application_gateway.value.subnet_cidr
      subnet_id    = ingress_application_gateway.value.subnet_id
    }
  }

  dynamic "key_management_service" {
    for_each = try(var.cluster.key_management_service, null) != null ? { "default" = var.cluster.key_management_service } : {}

    content {
      key_vault_key_id         = key_management_service.value.key_vault_key_id
      key_vault_network_access = key_management_service.value.key_vault_network_access
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = try(var.cluster.key_vault_secrets_provider, null) != null ? { "default" = var.cluster.key_vault_secrets_provider } : {}

    content {
      secret_rotation_enabled  = key_vault_secrets_provider.value.secret_rotation_enabled
      secret_rotation_interval = key_vault_secrets_provider.value.secret_rotation_interval
    }
  }

  dynamic "kubelet_identity" {
    for_each = try(var.cluster.kubelet_identity, null) != null ? [var.cluster.kubelet_identity] : []
    content {
      user_assigned_identity_id = kubelet_identity.value.user_assigned_identity_id
      client_id                 = kubelet_identity.value.client_id
      object_id                 = kubelet_identity.value.object_id
    }
  }

  dynamic "linux_profile" {
    for_each = try(var.cluster.linux_profile, null) != null ? { "default" = var.cluster.linux_profile } : try(var.cluster.generate_ssh_key.enable, false) || try(var.cluster.public_key, null) != null ? { "default" = {} } : {}

    content {
      admin_username = coalesce(var.cluster.username, try(linux_profile.value.admin_username, null), "nodeadmin")
      ssh_key {
        key_data = coalesce(var.cluster.public_key, try(linux_profile.value.ssh_key.key_data, null), tls_private_key.tls_key["ssh_key"].public_key_openssh)
      }
    }
  }

  dynamic "maintenance_window" {
    for_each = try(var.cluster.maintenance_window, null) != null ? { "default" = var.cluster.maintenance_window } : {}

    content {
      dynamic "allowed" {
        for_each = {
          for k, v in var.cluster.maintenance_window.allowed != null ? var.cluster.maintenance_window.allowed : {} : k => v
        }
        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }
      dynamic "not_allowed" {
        for_each = {
          for k, v in var.cluster.maintenance_window.not_allowed != null ? var.cluster.maintenance_window.not_allowed : {} : k => v
        }
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  dynamic "maintenance_window_auto_upgrade" {
    for_each = try(var.cluster.maintenance_window_auto_upgrade, null) != null ? { "default" = var.cluster.maintenance_window_auto_upgrade } : {}

    content {
      dynamic "not_allowed" {
        for_each = {
          for k, v in var.cluster.maintenance_window_auto_upgrade.not_allowed != null ? var.cluster.maintenance_window_auto_upgrade.not_allowed : {} : k => v
        }
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }

      frequency    = maintenance_window_auto_upgrade.value.frequency
      interval     = maintenance_window_auto_upgrade.value.interval
      duration     = maintenance_window_auto_upgrade.value.duration
      day_of_week  = maintenance_window_auto_upgrade.value.day_of_week
      day_of_month = maintenance_window_auto_upgrade.value.day_of_month
      week_index   = maintenance_window_auto_upgrade.value.week_index
      start_time   = maintenance_window_auto_upgrade.value.start_time
      utc_offset   = maintenance_window_auto_upgrade.value.utc_offset
      start_date   = maintenance_window_auto_upgrade.value.start_date
    }
  }

  dynamic "maintenance_window_node_os" {
    for_each = try(var.cluster.maintenance_window_node_os, null) != null ? { "default" = var.cluster.maintenance_window_node_os } : {}

    content {
      dynamic "not_allowed" {
        for_each = {
          for k, v in var.cluster.maintenance_window_node_os.not_allowed != null ? var.cluster.maintenance_window_node_os.not_allowed : {} : k => v
        }
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }

      frequency    = maintenance_window_node_os.value.frequency
      interval     = maintenance_window_node_os.value.interval
      duration     = maintenance_window_node_os.value.duration
      day_of_week  = maintenance_window_node_os.value.day_of_week
      day_of_month = maintenance_window_node_os.value.day_of_month
      week_index   = maintenance_window_node_os.value.week_index
      start_time   = maintenance_window_node_os.value.start_time
      utc_offset   = maintenance_window_node_os.value.utc_offset
      start_date   = maintenance_window_node_os.value.start_date
    }
  }

  dynamic "microsoft_defender" {
    for_each = try(var.cluster.microsoft_defender, null) != null ? { "default" = var.cluster.microsoft_defender } : {}

    content {
      log_analytics_workspace_id = microsoft_defender.value.log_analytics_workspace_id
    }
  }

  dynamic "monitor_metrics" {
    for_each = try(var.cluster.monitor_metrics, null) != null ? { "default" = var.cluster.monitor_metrics } : {}

    content {
      annotations_allowed = monitor_metrics.value.annotations_allowed
      labels_allowed      = monitor_metrics.value.labels_allowed
    }
  }

  dynamic "network_profile" {
    for_each = try(var.cluster.network_profile, null) != null ? { "default" = var.cluster.network_profile } : {}

    content {
      network_plugin      = network_profile.value.network_plugin
      network_mode        = network_profile.value.network_mode
      network_policy      = network_profile.value.network_policy
      dns_service_ip      = network_profile.value.dns_service_ip
      outbound_type       = network_profile.value.outbound_type
      pod_cidr            = network_profile.value.pod_cidr
      service_cidr        = network_profile.value.service_cidr
      load_balancer_sku   = network_profile.value.load_balancer_sku
      pod_cidrs           = network_profile.value.pod_cidrs
      ip_versions         = network_profile.value.ip_versions
      network_data_plane  = network_profile.value.network_data_plane
      service_cidrs       = network_profile.value.service_cidrs
      network_plugin_mode = network_profile.value.network_plugin_mode

      dynamic "load_balancer_profile" {
        for_each = try(network_profile.value.load_balancer_profile, null) != null ? { "default" = network_profile.value.load_balancer_profile } : {}

        content {
          managed_outbound_ip_count   = load_balancer_profile.value.managed_outbound_ip_count
          outbound_ip_prefix_ids      = load_balancer_profile.value.outbound_ip_prefix_ids
          outbound_ip_address_ids     = load_balancer_profile.value.outbound_ip_address_ids
          outbound_ports_allocated    = load_balancer_profile.value.outbound_ports_allocated
          backend_pool_type           = load_balancer_profile.value.backend_pool_type
          idle_timeout_in_minutes     = load_balancer_profile.value.idle_timeout_in_minutes
          managed_outbound_ipv6_count = load_balancer_profile.value.managed_outbound_ipv6_count
        }
      }

      dynamic "nat_gateway_profile" {
        for_each = try(network_profile.value.nat_gateway_profile, null) != null ? { "default" = network_profile.value.nat_gateway_profile } : {}

        content {
          idle_timeout_in_minutes   = nat_gateway_profile.value.idle_timeout_in_minutes
          managed_outbound_ip_count = nat_gateway_profile.value.managed_outbound_ip_count
        }
      }
    }
  }

  dynamic "oms_agent" {
    for_each = try(var.cluster.oms_agent, null) != null ? { "default" = var.cluster.oms_agent } : {}

    content {
      log_analytics_workspace_id      = oms_agent.value.log_analytics_workspace_id
      msi_auth_for_monitoring_enabled = oms_agent.value.enable.msi_auth_for_monitoring
    }
  }

  dynamic "service_mesh_profile" {
    for_each = try(var.cluster.service_mesh_profile, null) != null ? { "default" = var.cluster.service_mesh_profile } : {}

    content {
      revisions                        = service_mesh_profile.value.revisions
      mode                             = service_mesh_profile.value.mode
      internal_ingress_gateway_enabled = service_mesh_profile.value.internal_ingress_gateway_enabled
      external_ingress_gateway_enabled = service_mesh_profile.value.external_ingress_gateway_enabled

      dynamic "certificate_authority" {
        for_each = try(service_mesh_profile.value.certificate_authority, null) != null ? { "default" = service_mesh_profile.value.certificate_authority } : {}

        content {
          key_vault_id           = certificate_authority.value.key_vault_id
          root_cert_object_name  = certificate_authority.value.root_cert_object_name
          cert_chain_object_name = certificate_authority.value.cert_chain_object_name
          cert_object_name       = certificate_authority.value.cert_object_name
          key_object_name        = certificate_authority.value.key_object_name
        }
      }
    }
  }

  dynamic "workload_autoscaler_profile" {
    for_each = try(var.cluster.workload_autoscaler_profile, null) != null ? { default = var.cluster.workload_autoscaler_profile } : {}

    content {
      keda_enabled                    = workload_autoscaler_profile.value.keda_enabled
      vertical_pod_autoscaler_enabled = workload_autoscaler_profile.value.vertical_pod_autoscaler_enabled
    }
  }

  dynamic "storage_profile" {
    for_each = try(var.cluster.storage_profile, null) != null ? { "default" = var.cluster.storage_profile } : {}

    content {
      blob_driver_enabled         = storage_profile.value.blob_driver_enabled
      disk_driver_enabled         = storage_profile.value.disk_driver_enabled
      file_driver_enabled         = storage_profile.value.file_driver_enabled
      snapshot_controller_enabled = storage_profile.value.snapshot_controller_enabled
    }
  }

  dynamic "upgrade_override" {
    for_each = try(var.cluster.upgrade_override, null) != null ? { "default" = var.cluster.upgrade_override } : {}

    content {
      force_upgrade_enabled = upgrade_override.value.force_upgrade_enabled
      effective_until       = upgrade_override.value.effective_until
    }
  }

  dynamic "web_app_routing" {
    for_each = try(var.cluster.web_app_routing, null) != null ? { "default" = var.cluster.web_app_routing } : {}
    content {
      dns_zone_ids             = web_app_routing.value.dns_zone_ids
      default_nginx_controller = web_app_routing.value.default_nginx_controller
    }
  }

  dynamic "windows_profile" {
    for_each = try(var.cluster.windows_profile, null) != null ? { "default" = var.cluster.windows_profile } : {}
    content {
      admin_username = coalesce(var.cluster.username, windows_profile.value.admin_username, "nodeadmin")
      admin_password = coalesce(var.cluster.password, windows_profile.value.admin_password, azurerm_key_vault_secret.secret["default"].value)
      license        = windows_profile.value.license
      dynamic "gmsa" {
        for_each = try(windows_profile.value.gmsa, null) != null ? { "default" = windows_profile.value.gmsa } : {}
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
  for_each = var.cluster.profile == "linux" && try(var.cluster.generate_ssh_key.enable, false) == true ? { "ssh_key" = true } : {}

  algorithm   = var.cluster.generate_ssh_key.algorithm
  rsa_bits    = var.cluster.generate_ssh_key.rsa_bits
  ecdsa_curve = var.cluster.generate_ssh_key.ecdsa_curve
}

resource "azurerm_key_vault_secret" "tls_public_key_secret" {
  for_each = var.cluster.profile == "linux" && try(var.cluster.generate_ssh_key.enable, false) == true ? { "ssh_key" = true } : {}

  name             = format("%s-%s-%s", "kvs", var.cluster.name, "pub")
  value            = tls_private_key.tls_key["ssh_key"].public_key_openssh
  key_vault_id     = var.keyvault
  expiration_date  = var.cluster.generate_ssh_key.expiration_date
  not_before_date  = var.cluster.generate_ssh_key.not_before_date
  value_wo_version = var.cluster.generate_ssh_key.value_wo_version
  value_wo         = var.cluster.generate_ssh_key.value_wo
  content_type     = var.cluster.generate_ssh_key.content_type

  tags = coalesce(
    var.cluster.tags, var.tags, {}
  )
}

resource "azurerm_key_vault_secret" "tls_private_key_secret" {
  for_each = var.cluster.profile == "linux" && try(var.cluster.generate_ssh_key.enable, false) == true ? { "ssh_key" = true } : {}

  name             = format("%s-%s-%s", "kvs", var.cluster.name, "priv")
  value            = tls_private_key.tls_key["ssh_key"].private_key_pem
  key_vault_id     = var.keyvault
  expiration_date  = var.cluster.generate_ssh_key.expiration_date
  not_before_date  = var.cluster.generate_ssh_key.not_before_date
  value_wo         = var.cluster.generate_ssh_key.value_wo
  value_wo_version = var.cluster.generate_ssh_key.value_wo_version
  content_type     = var.cluster.generate_ssh_key.content_type

  tags = coalesce(
    var.cluster.tags, var.tags, {}
  )
}

# random password
resource "random_password" "password" {
  for_each = var.cluster.profile == "windows" && try(var.cluster.generate_password.enable, false) == true ? { "password" = true } : {}

  length           = var.cluster.generate_password.length
  special          = var.cluster.generate_password.special
  min_lower        = var.cluster.generate_password.min_lower
  min_upper        = var.cluster.generate_password.min_upper
  min_special      = var.cluster.generate_password.min_special
  min_numeric      = var.cluster.generate_password.min_numeric
  numeric          = var.cluster.generate_password.numeric
  upper            = var.cluster.generate_password.upper
  lower            = var.cluster.generate_password.lower
  override_special = var.cluster.generate_password.override_special
  keepers          = var.cluster.generate_password.keepers
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = var.cluster.profile == "windows" && try(var.cluster.generate_password.enable, false) == true ? { "password" = true } : {}

  name             = format("%s-%s", "kvs", var.cluster.name)
  value            = random_password.password["password"].result
  key_vault_id     = var.keyvault
  value_wo_version = var.cluster.generate_password.value_wo_version
  value_wo         = var.cluster.generate_password.value_wo
  content_type     = var.cluster.generate_password.content_type
  not_before_date  = var.cluster.generate_password.not_before_date
  expiration_date  = var.cluster.generate_password.expiration_date

  tags = coalesce(
    var.cluster.tags, var.tags, {}
  )
}

# node pools
resource "azurerm_kubernetes_cluster_node_pool" "pools" {
  for_each = {
    for pools_key, pools in lookup(var.cluster, "node_pools", {}) : pools_key => pools
  }

  name                          = each.value.name != null ? each.value.name : (each.value.os_type == "Linux" ? "npl${each.key}" : "npw${each.key}")
  kubernetes_cluster_id         = azurerm_kubernetes_cluster.aks.id
  vm_size                       = each.value.vm_size
  node_count                    = each.value.node_count
  max_count                     = each.value.max_count
  min_count                     = each.value.min_count
  zones                         = each.value.zones
  auto_scaling_enabled          = each.value.auto_scaling_enabled
  host_encryption_enabled       = each.value.host_encryption_enabled
  node_public_ip_enabled        = each.value.node_public_ip_enabled
  fips_enabled                  = each.value.enable.fips
  eviction_policy               = each.value.eviction_policy
  gpu_instance                  = each.value.gpu_instance
  kubelet_disk_type             = each.value.kubelet_disk_type
  os_disk_size_gb               = each.value.os_disk_size_gb
  os_disk_type                  = each.value.os_disk_type
  orchestrator_version          = each.value.orchestrator_version
  ultra_ssd_enabled             = each.value.ultra_ssd_enabled
  host_group_id                 = each.value.host_group_id
  pod_subnet_id                 = each.value.pod_subnet_id
  spot_max_price                = each.value.spot_max_price
  scale_down_mode               = each.value.scale_down_mode
  temporary_name_for_rotation   = each.value.temporary_name_for_rotation
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

  tags = coalesce(
    each.value.tags, var.cluster.tags, {}
  )

  dynamic "node_network_profile" {
    for_each = each.value.node_network_profile != null ? [each.value.node_network_profile] : []

    content {
      dynamic "allowed_host_ports" {
        for_each = node_network_profile.value.allowed_host_ports != null ? [node_network_profile.value.allowed_host_ports] : []

        content {
          port_start = allowed_host_ports.value.port_start
          port_end   = allowed_host_ports.value.port_end
          protocol   = allowed_host_ports.value.protocol
        }
      }
      application_security_group_ids = node_network_profile.value.application_security_group_ids
      node_public_ip_tags            = node_network_profile.value.node_public_ip_tags
    }
  }

  dynamic "upgrade_settings" {
    for_each = each.value.upgrade_settings != null ? [each.value.upgrade_settings] : []

    content {
      max_surge                     = upgrade_settings.value.max_surge
      drain_timeout_in_minutes      = upgrade_settings.value.drain_timeout_in_minutes
      node_soak_duration_in_minutes = upgrade_settings.value.node_soak_duration_in_minutes
    }
  }

  dynamic "linux_os_config" {
    for_each = each.value.os_type == "Linux" && each.value.linux_os_config != null ? [each.value.linux_os_config] : []

    content {
      swap_file_size_mb            = linux_os_config.value.swap_file_size_mb
      transparent_huge_page_defrag = linux_os_config.value.transparent_huge_page_defrag
      transparent_huge_page        = linux_os_config.value.transparent_huge_page

      dynamic "sysctl_config" {
        for_each = linux_os_config.value.sysctl_config != null ? [linux_os_config.value.sysctl_config] : []
        content {
          fs_aio_max_nr                      = sysctl_config.value.fs_aio_max_nr
          fs_file_max                        = sysctl_config.value.fs_file_max
          fs_inotify_max_user_watches        = sysctl_config.value.fs_inotify_max_user_watches
          fs_nr_open                         = sysctl_config.value.fs_nr_open
          kernel_threads_max                 = sysctl_config.value.kernel_threads_max
          net_core_netdev_max_backlog        = sysctl_config.value.net_core_netdev_max_backlog
          net_core_optmem_max                = sysctl_config.value.net_core_optmem_max
          net_core_rmem_default              = sysctl_config.value.net_core_rmem_default
          net_core_rmem_max                  = sysctl_config.value.net_core_rmem_max
          net_core_somaxconn                 = sysctl_config.value.net_core_somaxconn
          net_core_wmem_default              = sysctl_config.value.net_core_wmem_default
          net_core_wmem_max                  = sysctl_config.value.net_core_wmem_max
          net_ipv4_ip_local_port_range_min   = sysctl_config.value.net_ipv4_ip_local_port_range_min
          net_ipv4_ip_local_port_range_max   = sysctl_config.value.net_ipv4_ip_local_port_range_max
          net_ipv4_neigh_default_gc_thresh1  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh1
          net_ipv4_neigh_default_gc_thresh2  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh2
          net_ipv4_neigh_default_gc_thresh3  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh3
          net_ipv4_tcp_fin_timeout           = sysctl_config.value.net_ipv4_tcp_fin_timeout
          net_ipv4_tcp_keepalive_intvl       = sysctl_config.value.net_ipv4_tcp_keepalive_intvl
          net_ipv4_tcp_keepalive_probes      = sysctl_config.value.net_ipv4_tcp_keepalive_probes
          net_ipv4_tcp_keepalive_time        = sysctl_config.value.net_ipv4_tcp_keepalive_time
          net_ipv4_tcp_max_syn_backlog       = sysctl_config.value.net_ipv4_tcp_max_syn_backlog
          net_ipv4_tcp_max_tw_buckets        = sysctl_config.value.net_ipv4_tcp_max_tw_buckets
          net_ipv4_tcp_tw_reuse              = sysctl_config.value.net_ipv4_tcp_tw_reuse
          net_netfilter_nf_conntrack_buckets = sysctl_config.value.net_netfilter_nf_conntrack_buckets
          net_netfilter_nf_conntrack_max     = sysctl_config.value.net_netfilter_nf_conntrack_max
          vm_max_map_count                   = sysctl_config.value.vm_max_map_count
          vm_swappiness                      = sysctl_config.value.vm_swappiness
          vm_vfs_cache_pressure              = sysctl_config.value.vm_vfs_cache_pressure
        }
      }
    }
  }

  dynamic "kubelet_config" {
    for_each = each.value.os_type == "Linux" && each.value.kubelet_config != null ? [each.value.kubelet_config] : []

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

  dynamic "windows_profile" {
    for_each = each.value.os_type == "Windows" && each.value.windows_profile != null ? [each.value.windows_profile] : []

    content {
      outbound_nat_enabled = windows_profile.value.outbound_nat_enabled
    }
  }
}

resource "azurerm_kubernetes_cluster_extension" "ext" {
  for_each = var.cluster.extensions != null ? var.cluster.extensions : {}

  name                             = "ext-${each.key}"
  cluster_id                       = azurerm_kubernetes_cluster.aks.id
  extension_type                   = each.value.extension_type
  release_train                    = each.value.release_train
  target_namespace                 = each.value.target_namespace
  release_namespace                = each.value.release_namespace
  configuration_settings           = each.value.configuration_settings
  configuration_protected_settings = each.value.configuration_protected_settings
  version                          = each.value.version

  dynamic "plan" {
    for_each = each.value.plan != null ? each.value.plan : {}

    content {
      name           = plan.value.name
      publisher      = plan.value.publisher
      product        = plan.value.product
      promotion_code = plan.value.promotion_code
      version        = plan.value.version
    }
  }
}

# role assignment
resource "azurerm_role_assignment" "role" {
  for_each = lookup(var.cluster, "registry", null) != null ? { "default" = var.cluster.registry } : {}

  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.cluster.registry.role_assignment_scope
  skip_service_principal_aad_check = var.cluster.registry.skip_service_principal_aad_check
}
