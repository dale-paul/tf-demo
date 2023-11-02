
module "_defaults" {
  source = "./_defaults"
}

module "default" {
  source = "./default"
}

module "dev" {
  source = "./dev"
}

module "prod" {
  source = "./prod"
}

#can't use the reserved word here 'local' so use locals even though the workspace is local (see map)
module "locals" {
  source = "./local"
}

locals {
  data_map = {
    default = module.default.data,
    dev     = module.dev.data,
    prod    = module.prod.data,
    local   = module.locals.data,
  }
}

output "data" {
  value = {
    environment = "${terraform.workspace}"
    config = merge(
      module._defaults.data,
      lookup(local.data_map, terraform.workspace)
    )
  }
}

