This deploys the integration of a container registry within the cluster.

## Notes

If role_assignment_scope is defined in registry, the module creates an azurerm_role_assignment resource to assign the acrpull role to the kubernetes cluster's kubelet identity.
