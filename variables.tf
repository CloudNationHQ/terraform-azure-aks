variable "cluster" {
  description = "contains all aks cluster config"
  type        = any

  validation {
    condition     = contains(["windows", "linux"], lookup(var.cluster, "profile", "")) && (lookup(var.cluster, "profile", "") != "windows" || try(lookup(var.cluster.network, "plugin", "") == "azure", false))
    error_message = "The aks profile must be either 'windows' or 'linux'. If the profile is 'windows', 'var.cluster.network.plugin' must be 'azure'."
  }
}


variable "keyvault" {
  description = "keyvault to store secrets"
  type        = string
}

variable "location" {
  description = "default azure region and can be used if location is not specified inside the object."
  type        = string
  default     = null
}

variable "resourcegroup" {
  description = "default resource group and can be used if resourcegroup is not specified inside the object."
  type        = string
  default     = null
}
variable "monitor_metrics" {
  type    = map(string)
  default = null
}
