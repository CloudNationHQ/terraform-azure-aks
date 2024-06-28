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
      region = "westeurope"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 0.1"

  naming = local.naming

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

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
  version = "~> 0.1"

  keyvault = module.kv.vault.id

  cluster = {
    name               = "${module.naming.kubernetes_cluster.name}-01"
    location           = module.rg.groups.demo.location
    resourcegroup      = module.rg.groups.demo.name
    node_resourcegroup = "${module.rg.groups.demo.name}-node01"
    depends_on         = [module.kv]
    profile            = "windows"
    dns_prefix         = "demo1"
    sku_tier           = "Standard"

    network_profile = {
      network_plugin = "azure"
    }

    password = module.kv.secrets.password.value
  }
}

module "aks-linux" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.1"

  keyvault = module.kv.vault.id

  cluster = {
    name               = "${module.naming.kubernetes_cluster.name}-02"
    location           = module.rg.groups.demo.location
    resourcegroup      = module.rg.groups.demo.name
    node_resourcegroup = "${module.rg.groups.demo.name}-node02"
    depends_on         = [module.kv]
    profile            = "linux"
    dns_prefix         = "demo2"
    sku_tier           = "Standard"

    public_key = module.kv.tls_public_keys.tls.value
  }
}
