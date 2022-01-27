locals {
  marketing_feature_name = "marketing"
  marketing_tags = {
    Env       = var.ENV
    Terraform = true
    Feature   = local.marketing_feature_name
  }
}

module "cognito_user_pool" {
  source       = "../../modules/security/cognito"
  ENV          = var.ENV
  FEATURE_NAME = local.marketing_feature_name
  TAGS         = local.marketing_tags
}

# Marketing Infrastructure: START
module "marketing_vpc" {
  source                = "../../modules/network/vpc"
  ENV                   = var.ENV
  FEATURE_NAME          = local.marketing_feature_name
  AWS_REGION            = var.AWS_REGION
  VPC_CIDR              = var.VPC_CIDR
  PUBLIC_SUBNETS_CIDR   = var.PUBLIC_SUBNETS_CIDR
  PRIVATE_SUBNETS_CIDR  = var.PRIVATE_SUBNETS_CIDR
  DATABASE_SUBNETS_CIDR = var.DATABASE_SUBNETS_CIDR
  TAGS                  = local.marketing_tags
}

module "marketing_backend_pipeline" {
  source                         = "../../modules/cicd/marketing/backend"
  ENV                            = var.ENV
  BRANCH_NAME                    = var.BRANCH_NAME
  CODESTAR_CONNECTOR_CREDENTIALS = var.CODESTAR_CONNECTOR_CREDENTIALS
  TF_VERSION                     = var.TF_VERSION
  TF_BUCKET                      = var.TF_BUCKET
  TF_LOG                         = var.TF_LOG
  CODEPIPELINE_BUCKET            = var.CODEPIPELINE_BUCKET
  GITHUB_REPO                    = "TravelOffice/marketing_backend"
  TAGS                           = local.marketing_tags
}
module "marketing_postgresql" {
  source              = "../../modules/database/aurora/postgresql"
  ENV                 = var.ENV
  VPC_ID              = module.marketing_vpc.id
  DATABASE_SUBNETS    = module.marketing_vpc.database_subnets
  ALLOWED_CIDR_BLOCKS = [var.VPC_CIDR]
  FEATURE_NAME        = local.marketing_feature_name
  USERNAME            = var.RDS_USERNAME
  DATABASE_NAME       = local.marketing_feature_name
  ENGINE_MODE         = var.ENV == "dev" ? "serverless" : "provisioned"
  ENGINE_VERSION      = var.RDS_ENGINE_VERSION
  FAMILY              = var.RDS_FAMILY
  TAGS                = local.marketing_tags
}

module "marketing_secret_manager" {
  source       = "../../modules/security/secret_manager"
  ENV          = var.ENV
  FEATURE_NAME = local.marketing_feature_name
  STORE_DATA = {
    "RDS_WRITER_ENDPOINT" = module.marketing_postgresql.writer_endpoint
    "RDS_READER_ENDPOINT" = module.marketing_postgresql.reader_endpoint
    "RDS_NAME"            = local.marketing_feature_name
    "RDS_PORT"            = module.marketing_postgresql.port
    "RDS_USERNAME"        = var.RDS_USERNAME
    "RDS_PASSWORD"        = module.marketing_postgresql.cluster_password
  }
  TAGS = local.marketing_tags
}

module "standard_lambda_iam_role" {
  source = "../../modules/security/iam/role/lambda/standard"

  TAGS         = local.marketing_tags
  ENV          = var.ENV
  FEATURE_NAME = local.marketing_feature_name
}
# Marketing Infrastructure: END