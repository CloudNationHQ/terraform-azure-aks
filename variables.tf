variable "cluster" {
  description = "contains all aks cluster config"
  type = object({
    name                                = string
    location                            = optional(string)
    resource_group_name                 = optional(string)
    profile                             = string
    dns_prefix                          = optional(string)
    dns_prefix_private_cluster          = optional(string)
    automatic_upgrade_channel           = optional(string)
    ai_toolchain_operator_enabled       = optional(bool)
    azure_policy_enabled                = optional(bool, false)
    cost_analysis_enabled               = optional(bool)
    disk_encryption_set_id              = optional(string)
    edge_zone                           = optional(string)
    http_application_routing_enabled    = optional(bool)
    image_cleaner_enabled               = optional(bool)
    image_cleaner_interval_hours        = optional(number)
    kubernetes_version                  = optional(string)
    local_account_disabled              = optional(bool)
    node_os_upgrade_channel             = optional(string)
    node_resource_group                 = optional(string)
    oidc_issuer_enabled                 = optional(bool)
    open_service_mesh_enabled           = optional(bool)
    private_cluster_enabled             = optional(bool)
    private_dns_zone_id                 = optional(string)
    private_cluster_public_fqdn_enabled = optional(bool)
    custom_ca_trust_certificates_base64 = optional(list(string), [])
    workload_identity_enabled           = optional(bool)
    role_based_access_control_enabled   = optional(bool)
    run_command_enabled                 = optional(bool)
    sku_tier                            = optional(string)
    support_plan                        = optional(string)
    tags                                = optional(map(string))
    admin_username                      = optional(string)
    admin_password                      = optional(string)
    public_key                          = optional(string)
    service_principal = optional(object({
      client_id     = string
      client_secret = string
    }))
    generate_password = optional(object({
      enable           = optional(bool, false)
      name             = optional(string)
      length           = optional(number, 24)
      special          = optional(bool, true)
      min_lower        = optional(number, 5)
      min_upper        = optional(number, 7)
      min_special      = optional(number, 4)
      min_numeric      = optional(number, 5)
      numeric          = optional(bool, true)
      upper            = optional(bool, true)
      lower            = optional(bool, true)
      override_special = optional(string)
      keepers          = optional(map(string))
      value_wo_version = optional(string)
      value_wo         = optional(string)
      content_type     = optional(string)
      not_before_date  = optional(string)
      expiration_date  = optional(string)
    }), {})
    generate_ssh_key = optional(object({
      enable           = optional(bool, false)
      name             = optional(string)
      algorithm        = optional(string, "RSA")
      rsa_bits         = optional(number, 4096)
      ecdsa_curve      = optional(string, "P224")
      expiration_date  = optional(string)
      not_before_date  = optional(string)
      value_wo_version = optional(string)
      value_wo         = optional(string)
      content_type     = optional(string)
    }), {})
    identity = optional(object({
      type         = optional(string, "SystemAssigned")
      identity_ids = optional(list(string))
    }))
    default_node_pool = optional(object({
      name                          = optional(string, "default")
      vm_size                       = optional(string)
      capacity_reservation_group_id = optional(string)
      auto_scaling_enabled          = optional(bool)
      node_count                    = optional(number, 2)
      min_count                     = optional(number)
      max_count                     = optional(number)
      host_encryption_enabled       = optional(bool)
      node_public_ip_enabled        = optional(bool, false)
      gpu_instance                  = optional(string)
      host_group_id                 = optional(string)
      fips_enabled                  = optional(bool)
      kubelet_disk_type             = optional(string)
      max_pods                      = optional(number)
      node_public_ip_prefix_id      = optional(string)
      node_labels                   = optional(map(string))
      only_critical_addons_enabled  = optional(bool, false)
      orchestrator_version          = optional(string)
      os_disk_size_gb               = optional(number)
      os_disk_type                  = optional(string)
      os_sku                        = optional(string)
      pod_subnet_id                 = optional(string)
      proximity_placement_group_id  = optional(string)
      scale_down_mode               = optional(string)
      snapshot_id                   = optional(string)
      temporary_name_for_rotation   = optional(string)
      type                          = optional(string)
      tags                          = optional(map(string))
      ultra_ssd_enabled             = optional(bool)
      vnet_subnet_id                = optional(string)
      workload_runtime              = optional(string)
      zones                         = optional(list(number), [1, 2, 3])
      gpu_driver                    = optional(string)
      aci_connector_linux = optional(object({
        subnet_name = string
      }))
      kubelet_config = optional(object({
        allowed_unsafe_sysctls    = optional(list(string))
        container_log_max_files   = optional(number)
        container_log_max_size_mb = optional(number)
        cpu_cfs_quota_enabled     = optional(bool)
        cpu_cfs_quota_period      = optional(string)
        cpu_manager_policy        = optional(string, "none")
        image_gc_high_threshold   = optional(number)
        image_gc_low_threshold    = optional(number)
        pod_max_pid               = optional(number)
        topology_manager_policy   = optional(string)
      }))
      linux_os_config = optional(object({
        swap_file_size_mb            = optional(number)
        transparent_huge_page_defrag = optional(string)
        transparent_huge_page        = optional(string)
        sysctl_config = optional(object({
          fs_aio_max_nr                      = optional(number)
          fs_file_max                        = optional(number)
          fs_inotify_max_user_watches        = optional(number)
          fs_nr_open                         = optional(number)
          kernel_threads_max                 = optional(number)
          net_core_netdev_max_backlog        = optional(number)
          net_core_optmem_max                = optional(number)
          net_core_rmem_default              = optional(number)
          net_core_rmem_max                  = optional(number)
          net_core_somaxconn                 = optional(number)
          net_core_wmem_default              = optional(number)
          net_core_wmem_max                  = optional(number)
          net_ipv4_ip_local_port_range_max   = optional(number)
          net_ipv4_ip_local_port_range_min   = optional(number)
          net_ipv4_neigh_default_gc_thresh1  = optional(number)
          net_ipv4_neigh_default_gc_thresh2  = optional(number)
          net_ipv4_neigh_default_gc_thresh3  = optional(number)
          net_ipv4_tcp_fin_timeout           = optional(number)
          net_ipv4_tcp_keepalive_intvl       = optional(number)
          net_ipv4_tcp_keepalive_probes      = optional(number)
          net_ipv4_tcp_keepalive_time        = optional(number)
          net_ipv4_tcp_max_syn_backlog       = optional(number)
          net_ipv4_tcp_max_tw_buckets        = optional(number)
          net_ipv4_tcp_tw_reuse              = optional(bool)
          net_netfilter_nf_conntrack_buckets = optional(number)
          net_netfilter_nf_conntrack_max     = optional(number)
          vm_max_map_count                   = optional(number)
          vm_swappiness                      = optional(number)
          vm_vfs_cache_pressure              = optional(number)
        }))
      }))
      node_network_profile = optional(object({
        allowed_host_ports = optional(map(object({
          port_start = optional(number)
          port_end   = optional(number)
          protocol   = optional(string)
        })), {})
        application_security_group_ids = optional(list(string), [])
        node_public_ip_tags            = optional(map(string))
      }))
      upgrade_settings = optional(object({
        max_surge                     = optional(string, "1")
        drain_timeout_in_minutes      = optional(number)
        node_soak_duration_in_minutes = optional(number)
        undrainable_node_behavior     = optional(string)
      }))
    }), {})
    api_server_access_profile = optional(object({
      authorized_ip_ranges                = optional(list(string), [])
      subnet_id                           = optional(string)
      virtual_network_integration_enabled = optional(bool)
    }))
    auto_scaler_profile = optional(object({
      balance_similar_node_groups                   = optional(bool)
      expander                                      = optional(string)
      daemonset_eviction_for_empty_nodes_enabled    = optional(bool)
      daemonset_eviction_for_occupied_nodes_enabled = optional(bool)
      ignore_daemonsets_utilization_enabled         = optional(bool)
      max_graceful_termination_sec                  = optional(string)
      max_node_provisioning_time                    = optional(string)
      max_unready_nodes                             = optional(string)
      max_unready_percentage                        = optional(string)
      new_pod_scale_up_delay                        = optional(string)
      scale_down_delay_after_add                    = optional(string)
      scale_down_delay_after_delete                 = optional(string)
      scale_down_delay_after_failure                = optional(string)
      scan_interval                                 = optional(string)
      scale_down_unneeded                           = optional(string)
      scale_down_unready                            = optional(string)
      scale_down_utilization_threshold              = optional(string)
      empty_bulk_delete_max                         = optional(string)
      skip_nodes_with_local_storage                 = optional(bool)
      skip_nodes_with_system_pods                   = optional(bool)
    }))
    bootstrap_profile = optional(object({
      artifact_source       = optional(string)
      container_registry_id = optional(string)
    }))
    azure_active_directory_role_based_access_control = optional(object({
      tenant_id              = optional(string)
      admin_group_object_ids = optional(list(string))
      azure_rbac_enabled     = optional(bool, true)
    }))
    confidential_computing = optional(object({
      sgx_quote_helper_enabled = bool
    }))
    http_proxy_config = optional(object({
      http       = optional(string)
      https      = optional(string)
      exceptions = optional(list(string), [])
      trusted_ca = optional(string)
    }))
    ingress_application_gateway = optional(object({
      gateway_id   = optional(string)
      gateway_name = optional(string)
      subnet_cidr  = optional(string)
      subnet_id    = optional(string)
    }))
    key_management_service = optional(object({
      key_vault_key_id         = string
      key_vault_network_access = optional(string)
    }))
    key_vault_secrets_provider = optional(object({
      secret_rotation_enabled  = optional(bool, false)
      secret_rotation_interval = optional(string)
    }))
    kubelet_identity = optional(object({
      user_assigned_identity_id = string
      client_id                 = string
      object_id                 = string
    }))
    linux_profile = optional(object({
      admin_username = optional(string, "nodeadmin")
      ssh_key = optional(object({
        key_data = optional(string)
      }), {})
    }), {})
    maintenance_window = optional(object({
      allowed = optional(map(object({
        day   = string
        hours = list(string)
      })), {})
      not_allowed = optional(map(object({
        end   = string
        start = string
      })), {})
    }))
    maintenance_window_auto_upgrade = optional(object({
      not_allowed = optional(map(object({
        end   = string
        start = string
      })), {})
      frequency    = string
      interval     = number
      duration     = number
      day_of_week  = optional(string)
      day_of_month = optional(number)
      week_index   = optional(string)
      start_time   = optional(string)
      utc_offset   = optional(string)
      start_date   = optional(string)
    }))
    maintenance_window_node_os = optional(object({
      not_allowed = optional(map(object({
        end   = string
        start = string
      })), {})
      frequency    = string
      interval     = number
      duration     = number
      day_of_week  = optional(string)
      day_of_month = optional(number)
      week_index   = optional(string)
      start_time   = optional(string)
      utc_offset   = optional(string)
      start_date   = optional(string)
    }))
    microsoft_defender = optional(object({
      log_analytics_workspace_id = optional(string)
    }))
    monitor_metrics = optional(object({
      annotations_allowed = optional(string)
      labels_allowed      = optional(string)
    }))
    node_provisioning_profile = optional(object({
      mode               = optional(string, "Manual")
      default_node_pools = optional(string)
    }), {})
    network_profile = optional(object({
      network_plugin      = optional(string, "azure")
      network_mode        = optional(string)
      network_policy      = optional(string)
      dns_service_ip      = optional(string)
      outbound_type       = optional(string)
      pod_cidr            = optional(string)
      service_cidr        = optional(string)
      load_balancer_sku   = optional(string)
      pod_cidrs           = optional(list(string))
      ip_versions         = optional(list(string))
      network_data_plane  = optional(string)
      service_cidrs       = optional(list(string))
      network_plugin_mode = optional(string, "overlay")
      advanced_networking = optional(object({
        observability_enabled = optional(bool)
        security_enabled      = optional(bool)
      }))
      load_balancer_profile = optional(object({
        managed_outbound_ip_count   = optional(number)
        outbound_ip_prefix_ids      = optional(list(string))
        outbound_ip_address_ids     = optional(list(string))
        outbound_ports_allocated    = optional(number)
        backend_pool_type           = optional(string)
        idle_timeout_in_minutes     = optional(number)
        managed_outbound_ipv6_count = optional(number)
      }))
      nat_gateway_profile = optional(object({
        idle_timeout_in_minutes   = optional(string)
        managed_outbound_ip_count = optional(number)
      }))
    }))
    oms_agent = optional(object({
      log_analytics_workspace_id = optional(string)
      enable = optional(object({
        msi_auth_for_monitoring = optional(bool, false)
      }), {})
      retina_flow_logs_enabled = optional(bool)
    }))
    service_mesh_profile = optional(object({
      revisions                        = optional(list(string))
      mode                             = optional(string)
      internal_ingress_gateway_enabled = optional(bool, false)
      external_ingress_gateway_enabled = optional(bool, false)
      certificate_authority = optional(object({
        key_vault_id           = string
        root_cert_object_name  = string
        cert_chain_object_name = string
        cert_object_name       = string
        key_object_name        = string
      }))
    }))
    storage_profile = optional(object({
      blob_driver_enabled         = optional(bool)
      disk_driver_enabled         = optional(bool)
      file_driver_enabled         = optional(bool)
      snapshot_controller_enabled = optional(bool)
    }))
    upgrade_override = optional(object({
      force_upgrade_enabled = optional(bool, false)
      effective_until       = optional(string)
    }))
    web_app_routing = optional(object({
      dns_zone_ids             = list(string)
      default_nginx_controller = optional(string)
    }))
    windows_profile = optional(object({
      admin_username = optional(string, "nodeadmin")
      admin_password = optional(string)
      license        = optional(string)
      gmsa = optional(object({
        dns_server  = string
        root_domain = string
      }))
    }))
    workload_autoscaler_profile = optional(object({
      keda_enabled                    = optional(bool)
      vertical_pod_autoscaler_enabled = optional(bool)
    }))
    node_pools = optional(map(object({
      name                          = optional(string)
      vm_size                       = optional(string)
      node_count                    = optional(number)
      max_count                     = optional(number)
      min_count                     = optional(number)
      zones                         = optional(list(number))
      auto_scaling_enabled          = optional(bool, false)
      host_encryption_enabled       = optional(bool, false)
      node_public_ip_enabled        = optional(bool, false)
      eviction_policy               = optional(string)
      gpu_instance                  = optional(string)
      gpu_driver                    = optional(string)
      kubelet_disk_type             = optional(string)
      os_disk_size_gb               = optional(number)
      os_disk_type                  = optional(string)
      orchestrator_version          = optional(string)
      ultra_ssd_enabled             = optional(bool)
      host_group_id                 = optional(string)
      pod_subnet_id                 = optional(string)
      spot_max_price                = optional(number)
      scale_down_mode               = optional(string)
      temporary_name_for_rotation   = optional(string)
      node_public_ip_prefix_id      = optional(string)
      proximity_placement_group_id  = optional(string)
      capacity_reservation_group_id = optional(string)
      max_pods                      = optional(number)
      mode                          = optional(string)
      node_labels                   = optional(map(string))
      node_taints                   = optional(list(string), [])
      os_sku                        = optional(string)
      os_type                       = optional(string)
      priority                      = optional(string)
      snapshot_id                   = optional(string)
      workload_runtime              = optional(string)
      vnet_subnet_id                = optional(string)
      tags                          = optional(map(string))
      enable = optional(object({
        fips = optional(bool, false)
      }), {})
      node_network_profile = optional(object({
        allowed_host_ports = optional(map(object({
          port_start = optional(number)
          port_end   = optional(number)
          protocol   = optional(string)
        })), {})
        application_security_group_ids = optional(list(string), [])
        node_public_ip_tags            = optional(map(string))
      }))
      upgrade_settings = optional(object({
        max_surge                     = optional(string)
        drain_timeout_in_minutes      = optional(number)
        node_soak_duration_in_minutes = optional(number)
        max_unavailable               = optional(string)
        undrainable_node_behavior     = optional(string)
      }))
      linux_os_config = optional(object({
        swap_file_size_mb             = optional(number)
        transparent_huge_page_defrag  = optional(string, "madvise")
        transparent_huge_page_enabled = optional(string)
        sysctl_config = optional(object({
          fs_aio_max_nr                      = optional(number)
          fs_file_max                        = optional(number)
          fs_inotify_max_user_watches        = optional(number)
          fs_nr_open                         = optional(number)
          kernel_threads_max                 = optional(number)
          net_core_netdev_max_backlog        = optional(number)
          net_core_optmem_max                = optional(number)
          net_core_rmem_default              = optional(number)
          net_core_rmem_max                  = optional(number)
          net_core_somaxconn                 = optional(number)
          net_core_wmem_default              = optional(number)
          net_core_wmem_max                  = optional(number)
          net_ipv4_ip_local_port_range_min   = optional(number)
          net_ipv4_ip_local_port_range_max   = optional(number)
          net_ipv4_neigh_default_gc_thresh1  = optional(number)
          net_ipv4_neigh_default_gc_thresh2  = optional(number)
          net_ipv4_neigh_default_gc_thresh3  = optional(number)
          net_ipv4_tcp_fin_timeout           = optional(number)
          net_ipv4_tcp_keepalive_intvl       = optional(number)
          net_ipv4_tcp_keepalive_probes      = optional(number)
          net_ipv4_tcp_keepalive_time        = optional(number)
          net_ipv4_tcp_max_syn_backlog       = optional(number)
          net_ipv4_tcp_max_tw_buckets        = optional(number)
          net_ipv4_tcp_tw_reuse              = optional(bool)
          net_netfilter_nf_conntrack_buckets = optional(number)
          net_netfilter_nf_conntrack_max     = optional(number)
          vm_max_map_count                   = optional(number)
          vm_swappiness                      = optional(number)
          vm_vfs_cache_pressure              = optional(number)
        }))
      }))
      kubelet_config = optional(object({
        allowed_unsafe_sysctls    = optional(list(string))
        container_log_max_files   = optional(number)
        container_log_max_size_mb = optional(number)
        cpu_cfs_quota_enabled     = optional(bool)
        cpu_cfs_quota_period      = optional(string)
        cpu_manager_policy        = optional(string)
        image_gc_high_threshold   = optional(number)
        image_gc_low_threshold    = optional(number)
        pod_max_pid               = optional(number)
        topology_manager_policy   = optional(string)
      }))
      windows_profile = optional(object({
        outbound_nat_enabled = optional(bool)
      }))
    })), {})
    extensions = optional(map(object({
      name                             = optional(string)
      extension_type                   = string
      release_train                    = optional(string)
      target_namespace                 = optional(string)
      release_namespace                = optional(string)
      configuration_settings           = optional(map(string))
      configuration_protected_settings = optional(map(string))
      version                          = optional(string)
      plan = optional(object({
        name           = string
        publisher      = string
        product        = string
        promotion_code = optional(string)
        version        = optional(string)
      }))
    })), {})
    role_assignments = optional(map(object({
      scope                                  = string
      principal_id                           = optional(string)
      name                                   = optional(string)
      role_definition_name                   = optional(string)
      role_definition_id                     = optional(string)
      description                            = optional(string)
      principal_type                         = optional(string)
      condition                              = optional(string)
      condition_version                      = optional(string)
      delegated_managed_identity_resource_id = optional(string)
      skip_service_principal_aad_check       = optional(bool)
    })), {})
  })

  validation {
    condition     = contains(["windows", "linux"], var.cluster.profile)
    error_message = "The aks profile must be either 'windows' or 'linux'. This is needed to either create a password (windows) or a ssh key (linux)."
  }

  validation {
    condition     = var.cluster.profile != "windows" || var.cluster.generate_password != null || var.cluster.admin_password != null
    error_message = "Windows clusters must have either generate_password configured or admin_password provided."
  }
}

variable "keyvault" {
  description = "keyvault to store secrets"
  type        = string
  default     = null
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
