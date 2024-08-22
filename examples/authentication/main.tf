module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "germanywestcentral"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 1.0"

  naming = local.naming

  vault = {
    name           = module.naming.key_vault.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    secrets = {
      tls_keys = {
        tls = {
          algorithm = "RSA"
          key_size  = 2048
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
  version = "~> 1.0"

  cluster = {
    name               = "${module.naming.kubernetes_cluster.name}1"
    location           = module.rg.groups.demo.location
    resource_group     = module.rg.groups.demo.name
    node_resourcegroup = "${module.rg.groups.demo.name}n1"
    depends_on         = [module.kv]
    profile            = "windows"
    dns_prefix         = "demo1"
    sku_tier           = "Standard"
    password           = module.kv.secrets.password.value

    identity = {
      type = "UserAssigned"
    }

    network_profile = {
      network_plugin = "azure"
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
  version = "~> 1.0"

  cluster = {
    name                = "${module.naming.kubernetes_cluster.name}2"
    location            = module.rg.groups.demo.location
    resource_group      = module.rg.groups.demo.name
    node_resource_group = "${module.rg.groups.demo.name}n2"
    depends_on          = [module.kv]
    profile             = "linux"
    dns_prefix          = "demo2"
    sku_tier            = "Standard"
    public_key          = module.kv.tls_public_keys.tls.value

    identity = {
      type = "UserAssigned"
    }

    default_node_pool = {
      upgrade_settings = {
        max_surge = "10%"
      }
    }
  }
}
