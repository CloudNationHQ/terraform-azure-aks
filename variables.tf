variable "cluster" {
  description = "contains all aks cluster config"
  type        = any

  validation {
    condition     = contains(["windows", "linux"], lookup(var.cluster, "profile", ""))
    error_message = "The aks profile must be either 'windows' or 'linux'. This is needed to either create a password (windows) or a ssh key (linux)."
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
