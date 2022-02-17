locals {
  marketing_feature_name = "marketing-backend"
  sale_frontend_name     = "sale-frontend"
  base_backend_name        = "base-backend"
  marketing_tags = {
    Env       = var.ENV
    Terraform = true
    Feature   = local.marketing_feature_name
  }
  sale_frontend_tags = {
    Env       = var.ENV
    Terraform = true
    Feature   = local.sale_frontend_name
  }
  base_backend_tags = {
    Env       = var.ENV
    Terraform = true
    Feature   = local.base_backend_name
  }
}

# Tenant infrastrucutre: START
module "cognito_user_pool" {
  source = "../../modules/security/cognito"
  ENV    = var.ENV
  TAGS   = local.marketing_tags
}
module "base_backend_pipeline" {
  source                         = "../../modules/cicd"
  ENV                            = var.ENV
  BRANCH_NAME                    = var.BRANCH_NAME
  CODESTAR_CONNECTOR_CREDENTIALS = var.CODESTAR_CONNECTOR_CREDENTIALS
  TF_VERSION                     = var.TF_VERSION
  TF_BUCKET                      = var.TF_BUCKET
  TF_LOG                         = var.TF_LOG
  CODEPIPELINE_BUCKET            = var.CODEPIPELINE_BUCKET
  GITHUB_REPO                    = "TravelOffice/base_backend"
  FEATURE_NAME                   = local.base_backend_name
  TAGS                           = local.base_backend_tags
}
module "base_backend_vpc" {
  source               = "../../modules/network/vpc"
  ENV                  = var.ENV
  FEATURE_NAME         = local.base_backend_name
  AWS_REGION           = var.AWS_REGION
  VPC_CIDR             = var.BASE_BACKEND_VPC_CIDR
  PUBLIC_SUBNETS_CIDR  = var.BASE_BACKEND_PUBLIC_SUBNETS_CIDR
  PRIVATE_SUBNETS_CIDR = var.BASE_BACKEND_PRIVATE_SUBNETS_CIDR
  TAGS                 = local.base_backend_tags
}

module "cognito_power_user_lambda_role" {
  source = "../../modules/security/iam/role/lambda/cognito_power_user"

  TAGS         = local.base_backend_tags
  ENV          = var.ENV
  FEATURE_NAME = local.base_backend_name
}
module "provisioning_tenant_infra_ecs_task_role" {
  source = "../../modules/security/iam/role/ecs/task"

  TAGS         = local.base_backend_tags
  ENV          = var.ENV
  FEATURE_NAME = local.base_backend_name
}

module "execute_ecs_task_lambda_role" {
  source = "../../modules/security/iam/role/lambda/execute_ecs_task"

  TAGS          = local.base_backend_tags
  ENV           = var.ENV
  FEATURE_NAME  = local.base_backend_name
  ECS_TASK_ROLE = module.provisioning_tenant_infra_ecs_task_role.arn
}

module "base_backend_secret_manager" {
  source       = "../../modules/security/secret_manager"
  ENV          = var.ENV
  FEATURE_NAME = local.base_backend_name
  STORE_DATA = {
    "COGNITO_USER_POOL_ID" = module.cognito_user_pool.id
    "COGNITO_CLIENT_ID"    = module.cognito_user_pool.client_ids[0]
  }
  TAGS = local.marketing_tags
}
# Tenant infrastrucutre: END

# Marketing Infrastructure: START
module "marketing_vpc" {
  source                = "../../modules/network/vpc"
  ENV                   = var.ENV
  FEATURE_NAME          = local.marketing_feature_name
  AWS_REGION            = var.AWS_REGION
  VPC_CIDR              = var.MARKETING_VPC_CIDR
  PUBLIC_SUBNETS_CIDR   = var.MARKETING_PUBLIC_SUBNETS_CIDR
  PRIVATE_SUBNETS_CIDR  = var.MARKETING_PRIVATE_SUBNETS_CIDR
  DATABASE_SUBNETS_CIDR = var.MARKETING_DATABASE_SUBNETS_CIDR
  TAGS                  = local.marketing_tags
}

module "sale_frontend_pipeline" {
  source                         = "../../modules/cicd"
  ENV                            = var.ENV
  BRANCH_NAME                    = var.BRANCH_NAME
  CODESTAR_CONNECTOR_CREDENTIALS = var.CODESTAR_CONNECTOR_CREDENTIALS
  TF_VERSION                     = var.TF_VERSION
  TF_BUCKET                      = var.TF_BUCKET
  TF_LOG                         = var.TF_LOG
  CODEPIPELINE_BUCKET            = var.CODEPIPELINE_BUCKET
  GITHUB_REPO                    = "TravelOffice/sale_web"
  FEATURE_NAME                   = local.sale_frontend_name
  TAGS                           = local.sale_frontend_tags
}

module "marketing_backend_pipeline" {
  source                         = "../../modules/cicd"
  ENV                            = var.ENV
  BRANCH_NAME                    = var.BRANCH_NAME
  CODESTAR_CONNECTOR_CREDENTIALS = var.CODESTAR_CONNECTOR_CREDENTIALS
  TF_VERSION                     = var.TF_VERSION
  TF_BUCKET                      = var.TF_BUCKET
  TF_LOG                         = var.TF_LOG
  CODEPIPELINE_BUCKET            = var.CODEPIPELINE_BUCKET
  GITHUB_REPO                    = "TravelOffice/marketing_backend"
  FEATURE_NAME                   = local.marketing_feature_name
  TAGS                           = local.marketing_tags
}
module "marketing_postgresql" {
  source              = "../../modules/database/aurora/postgresql"
  ENV                 = var.ENV
  VPC_ID              = module.marketing_vpc.id
  DATABASE_SUBNETS    = module.marketing_vpc.database_subnets
  ALLOWED_CIDR_BLOCKS = [var.MARKETING_VPC_CIDR]
  FEATURE_NAME        = local.marketing_feature_name
  USERNAME            = var.RDS_USERNAME
  DATABASE_NAME       = "marketing"
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