terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {}
}

#provider to redirect to localstack
provider "aws" {
  # profile      = "localstack"
  access_key = "test"
  secret_key = "test"
  region     = local.region


  s3_use_path_style           = true
  skip_credentials_validation = true
  # skip_metadata_api_check     = true
  skip_requesting_account_id  = false

  endpoints {
    s3         = "http://localhost:4566"
    dynamodb   = "http://localhost:4566"
    ssm        = "http://localhost:4566"
    iam        = "http://localhost:4566"
    lambda     = "http://localhost:4566"
    apigateway = "http://localhost:4566"
  }
}

# data "aws_caller_identity" "current" {}

locals {
  app_tags = {
    environment = local.environment,
    version     = "v1.0.3"
  }
  # cannot use real secrets here as it shows up in the state file. Replace with real values outside of TF
  secrets              = jsondecode(file("./slack_secrets_(env).json"))
  appname              = "pssst"
  workspace            = module.workspaces.data.config
  environment          = module.workspaces.data.environment
  region               = local.workspace.region
  accounts_list        = [for map in module.accounts.data : map.account_id]
  deploy_account_info  = lookup(module.accounts.data, var.deploy_to_account)
  deploy_account_id    = local.deploy_account_info.account_id
  assume_role_arn      = "arn:aws:iam::${local.deploy_account_id}:role/${local.deploy_account_info.deployer_iam_role_name}"
  ddb_tablename        = "mydb-${local.environment}"
  tags                 = merge(local.app_tags, local.workspace.common_tags)
}

# Configuration data for each environment workspace
module "workspaces" {
  source = "./workspaces"
}

# ***************
#  Modules can be pointed to localstack by changing the provider to aws.localstack
# ***************

module "accounts" {
  source = "./modules/accounts"

}

module "web_bucket" {
  source = "./modules/s3"

  bucket_name = "${local.appname}-website-${local.environment}"
  environment = local.environment
  tags        = local.tags
}

module "secrets_db" {
  source = "./modules/dynamodb"

  table_name  = local.ddb_tablename
  environment = local.environment
  tags        = local.tags
}

module "slack_secrets" {
  source = "./modules/ssm"

  environment  = local.environment
  ssmparamkeys = local.secrets
}

module "pssst_iam" {
  source = "./modules/iam"

  environment = local.environment
  region      = local.region
  table_name  = module.secrets_db.data.table_name
  account     = local.deploy_account_id
}

# module "pssst_lambda" {
#   providers = {
#     aws = aws
#   }
#   source      = "./modules/lambda"
#   lambda_name = local.appname
#   environment = local.environment
#   role_arn    = module.pssst_iam.data.role_arn
#   source_path = local.artifact_source_path
#   tags        = local.tags
#   env_variables = {
#     ddb_table   = local.ddb_tablename,
#     environment = local.environment,
#     appname     = local.appname,
#   }
# }
