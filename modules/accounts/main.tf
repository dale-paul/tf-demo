

locals {
  localstack = {
    account_id             = "000000000000"
    deployer_iam_role_name = "localstack-role"
  }

  devops = {
    account_id             = "012345678901"
    deployer_iam_role_name = "Devops_Admin"
  }

  devops2 = {
    account_id             = "234567890123"
    deployer_iam_role_name = "Devops_Admin"
  }


  accounts_map = {
    localstack = local.localstack
    devops   = local.devops
    devops2  = local.devops2
  }
}

output "data" {
  value = local.accounts_map
}