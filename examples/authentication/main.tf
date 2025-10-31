module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "sweden central"
    }
  }
}

module "identity" {
  source  = "cloudnationhq/uai/azure"
  version = "~> 2.0"

  config = {
    name                = module.naming.user_assigned_identity.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 4.0"

  naming = local.naming

  vault = {
    name                = module.naming.key_vault.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    secrets = {
      tls_keys = {
        tls = {
          algorithm = "RSA"
        }
      }
      random_string = {
        password = {
          length  = 24
          special = false
        }
      }
    }
  }
}

module "aks-windows" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 3.0"

  cluster = {
    name                = "${module.naming.kubernetes_cluster.name}1"
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    node_resource_group = "${module.rg.groups.demo.name}n1"
    profile             = "windows"
    dns_prefix          = "demo1"
    sku_tier            = "Standard"
    password            = module.kv.secrets.password.value

    identity = {
      type         = "UserAssigned"
      identity_ids = [module.identity.config.id]
    }

    default_node_pool = {
      upgrade_settings = {
        max_surge = "10%"
      }
    }
  }
}

module "aks-linux" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 4.0"

  cluster = {
    name                = "${module.naming.kubernetes_cluster.name}2"
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    node_resource_group = "${module.rg.groups.demo.name}n2"
    profile             = "linux"
    dns_prefix          = "demo2"
    sku_tier            = "Standard"
    public_key          = module.kv.tls_public_keys.tls.value

    identity = {
      type         = "UserAssigned"
      identity_ids = [module.identity.config.id]
    }

    default_node_pool = {
      upgrade_settings = {
        max_surge = "10%"
      }
    }
  }
  depends_on = [module.kv]
}
