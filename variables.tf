variable "cluster" {
  description = "contains all aks cluster config"
  type        = any

  validation {
    condition     = contains(["windows", "linux"], lookup(var.cluster, "profile", "")) && (lookup(var.cluster, "profile", "") != "windows" || try(lookup(var.cluster.network_profile, "network_plugin", "") == "azure", false))
    error_message = "The aks profile must be either 'windows' or 'linux'. If the profile is 'windows', 'var.cluster.network.plugin' must be 'azure'."
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

variable "resource_group" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
