locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["key_vault_secret"]
}

locals {
  clusters = {
    cl1 = {
      node_resourcegroup = "rg-demo-dev-cl1-node"
      name               = "aks-demo-dev1"
      profile            = "linux"
      dns_prefix         = "cl1"
    }
    cl2 = {
      node_resourcegroup = "rg-demo-dev-cl2-node"
      name               = "aks-demo-dev2"
      profile            = "linux"
      dns_prefix         = "cl2"
    }
  }
}
