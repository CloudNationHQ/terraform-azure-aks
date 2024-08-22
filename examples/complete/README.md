# Complete

This example highlights the complete usage.

## Types

```hcl
cluster = object({
  name           = string
  location       = string
  resource_group = string
  depends_on     = optional(list(any))
  dns_prefix     = optional(string)
  profile        = optional(string)
  default_node_pool = optional(object({
    vm_size        = optional(string)
    vnet_subnet_id = optional(string)
    upgrade_settings = optional(object({
      max_surge = optional(number)
    }))
  }))
  monitor_metrics = optional(object({
    labels_allowed      = optional(string)
    annotations_allowed = optional(string)
  }))
  maintenance_window = optional(object({
    allowed = optional(map(object({
      day   = string
      hours = list(string)
    })))
  }))
  identity = optional(object({
    type         = string
    identity_ids = optional(list(string))
  }))
  kubelet_identity = optional(object({
    user_assigned_identity_id = string
    client_id                 = string
    object_id                 = string
  }))
  oms_agent = optional(object({
    log_analytics_workspace_id = string
  }))
  microsoft_defender_atp = optional(object({
    log_analytics_workspace_id = string
  }))
  key_vault_secrets_provider = optional(object({
    secret_rotation_enabled  = optional(bool)
    secret_rotation_interval = optional(string)
  }))
  network_profile = optional(object({
    network_plugin      = string  # This is now required
    network_plugin_mode = optional(string)
    load_balancer_profile = optional(object({
      managed_outbound_ip_count = optional(number)
    }))
  }))
  node_pools = optional(map(object({
    vm_size        = optional(string)
    vnet_subnet_id = optional(string)
    node_count     = optional(number)
    zones          = optional(list(number))
    mode           = optional(string)
    os_type        = optional(string)
    node_labels    = optional(map(string))
  })))
})
```

## Notes

When setting the identity type to UserAssigned, the module will generate a user-assigned identity automatically.

However, if you specify identity_ids under the identity property, the module will skip the generating one, and your specified identities will be used instead.

You can specify a custom kubelet identity using user_assigned_identity_id, client_id, and object_id.

Note that assigning the "Managed Identity Operator" role to the user-assigned identity is a requirement for proper permissions.
