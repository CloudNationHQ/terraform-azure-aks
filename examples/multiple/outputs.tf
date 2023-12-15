output "cluster_names" {
  value = {
    for cl_name, cl_config in local.clusters : cl_name => {
      name       = cl_config.name
      dns_prefix = cl_config.dns_prefix
    }
  }
}

output "clusters" {
  value = {
    for k, module_instance in module.aks : k => module_instance.cluster
  }
}
