locals {
  aks_pools = length(lookup(var.cluster, "node_pools", [])) > 0 ? flatten([
    for pools_key, pools in lookup(var.cluster, "node_pools", {}) : {

      pools_key  = pools_key
      vm_size    = try(pools.vm_size, "Standard_D2as_v5")
      node_count = try(pools.node_count, 1)
      max_count  = try(pools.max_count, 0)
      min_count  = try(pools.min_count, 0)
      max_surge  = try(pools.max_surge, 50)

      name = try(
        pools.name,
        pools.os_type == "Linux" ? "npl${pools_key}" : "npw${pools_key}"
      )

      linux_os_config = try(pools.config.linux_os, {
        swap_file_size_mb             = "none"
        transparent_huge_page_defrag  = "madvise"
        transparent_huge_page_enabled = "always"
      })

      kubelet_config = try(pools.config.kubelet, {
        allowed_unsafe_sysctls    = try(pools.config.kubelet.allowed_unsafe_sysctls, null)
        container_log_max_line    = try(pools.config.kubelet.container_log_max_line, null)
        container_log_max_size_mb = try(pools.config.kubelet.container_log_max_size_mb, null)
        cpu_cfs_quota_enabled     = try(pools.config.kubelet.cpu_cfs_quota_enabled, null)
        cpu_cfs_quota_period      = try(pools.config.kubelet.cpu_cfs_quota_period, null)
        cpu_manager_policy        = try(pools.config.kubelet.cpu_manager_policy, null)
        image_gc_high_threshold   = try(pools.config.kubelet.image_gc_high_threshold, null)
        image_gc_low_threshold    = try(pools.config.kubelet.image_gc_low_threshold, null)
        pod_max_pid               = try(pools.config.kubelet.pod_max_pid, null)
        topology_manager_policy   = try(pools.config.kubelet.topology_manager_policy, null)

      })
      workload_runtime              = try(pools.workload_runtime, null)
      snapshot_id                   = try(pools.snapshot_id, null)
      priority                      = try(pools.priority, null)
      os_type                       = try(pools.os_type, "Linux")
      os_sku                        = try(pools.os_sku, null)
      node_labels                   = try(pools.node_labels, {})
      node_taints                   = try(pools.node_taints, [])
      mode                          = try(pools.mode, "User")
      max_pods                      = try(pools.max_pods, 30)
      kubelet_disk_type             = try(pools.kubelet_disk_type, null)
      eviction_policy               = try(pools.eviction_policy, null)
      enable_fips                   = try(pools.enable.fips, false)
      zones                         = try(pools.zones, null)
      enable_node_public_ip         = try(pools.enable_node_public_ip, false)
      enable_auto_scaling           = try(pools.enable_auto_scaling, false)
      enable_host_encryption        = try(pools.enable_host_encryption, false)
      vnet_subnet_id                = try(pools.vnet_subnet_id, null)
      os_disk_size_gb               = try(pools.os_disk_size_gb, null)
      os_disk_type                  = try(pools.os_disk_type, null)
      orchestrator_version          = try(pools.orchestrator_version, null)
      message_of_the_day            = try(pools.message_of_the_day, null)
      host_group_id                 = try(pools.host_group_id, null)
      pod_subnet_id                 = try(pools.pod_subnet_id, null)
      spot_max_price                = try(pools.spot_max_price, null)
      scale_down_mode               = try(pools.scale_down_mode, null)
      node_public_ip_prefix_id      = try(pools.node_public_ip_prefix_id, null)
      proximity_placement_group_id  = try(pools.proximity_placement_group_id, null)
      capacity_reservation_group_id = try(pools.capacity_reservation_group_id, null)
      ultra_ssd_enabled             = try(pools.ultra_ssd_enabled, false)
      tags                          = try(pools.tags, var.cluster.tags, null)

      custom_ca_trust = try(pools.custom_ca_trust, false)
      zones           = try(pools.zones, [])
    }
  ]) : []
}
