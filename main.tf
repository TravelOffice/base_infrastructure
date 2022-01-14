locals {
  marketing_tags = {
    Env       = var.ENV
    Terraform = true
    Feature   = "marketing" 
  }
}

# Marketing Infrastructure: START
module "marketing_vpc" {
  source                = "../../modules/network/vpc"
  ENV                   = var.ENV
  FEATURE_NAME          = "marketing"
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
  FEATURE_NAME        = "marketing"
  USERNAME            = var.RDS_USERNAME
  DATABASE_NAME       = "marketing"
  TAGS                = local.marketing_tags
}

module "marketing_secret_manager" {
  source       = "../../modules/security/secret_manager"
  ENV          = var.ENV
  FEATURE_NAME = "marketing"
  STORE_DATA = {
    "RDS_WRITER_ENDPOINT" = module.marketing_postgresql.writer_endpoint
    "RDS_READER_ENDPOINT" = module.marketing_postgresql.reader_endpoint
    "RDS_NAME"            = "marketing"
    "RDS_PORT"            = module.marketing_postgresql.port
    "RDS_USERNAME"        = var.RDS_USERNAME
    "RDS_PASSWORD"        = module.marketing_postgresql.cluster_password
  }
  TAGS = local.marketing_tags
}
# Marketing Infrastructure: END