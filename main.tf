locals {
  hosted_zone_id         = "Z0837421MRKFPV1O1ZCI"
  acm                    = "arn:aws:acm:us-east-1:249593777629:certificate/20027980-d231-448a-930d-b37a515342dd"
  marketing_feature_name = "marketing-backend"
  sale_frontend_name     = "sale-frontend"
  base_backend_name      = "base-backend"
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
  is_prod = var.ENV == "prod"
  code_build_env = {
    common = [
      {
        name  = "TF_BUCKET"
        value = var.TF_BUCKET
      },
      {
        name  = "BUILD_ENV"
        value = var.ENV
      },
      {
        name  = "TF_VERSION"
        value = var.TF_VERSION
      },
      {
        name  = "TF_LOG"
        value = var.TF_LOG
      }
    ],
    sale_web = [
      {
        name  = "REACT_APP_BASE_URL"
        value = "localhost:5000/"
      },
      {
        name  = "REACT_APP_SSO_PAGE"
        value = "https://sso.traveloffice.shop"
      },
      {
        name  = "REACT_APP_APPSYNC_API_ENDPOINT"
        value = module.chat_appsync.domain
      },
      {
        name  = "REACT_APP_AWS_REGION"
        value = var.AWS_REGION
      },
      {
        name  = "REACT_APP_APPSYNC_REALTIME_ENDPOINT"
        value = "${module.chat_appsync.domain}/realtime"
      }
    ]
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
  ENV_VARS                       = local.code_build_env.common
  CODEPIPELINE_BUCKET            = var.CODEPIPELINE_BUCKET
  GITHUB_REPO                    = "TravelOffice/base_backend"
  FEATURE_NAME                   = local.base_backend_name
  TAGS                           = local.base_backend_tags
}
module "base_backend_vpc" {
  source                 = "../../modules/network/vpc"
  ENV                    = var.ENV
  FEATURE_NAME           = local.base_backend_name
  AWS_REGION             = var.AWS_REGION
  VPC_CIDR               = var.BASE_BACKEND_VPC_CIDR
  PUBLIC_SUBNETS_CIDR    = var.BASE_BACKEND_PUBLIC_SUBNETS_CIDR
  PRIVATE_SUBNETS_CIDR   = var.BASE_BACKEND_PRIVATE_SUBNETS_CIDR
  SINGLE_NAT_GATEWAY     = local.is_prod ? false : true
  ONE_NAT_GATEWAY_PER_AZ = local.is_prod ? true : false
  TAGS                   = local.base_backend_tags
}
module "standard_lambda_role" {
  source = "../../modules/security/iam/role/lambda/standard"

  TAGS         = local.marketing_tags
  ENV          = var.ENV
  FEATURE_NAME = local.marketing_feature_name
}
module "send_mail_lambda_role" {
  source = "../../modules/security/iam/role/lambda/send_mail"

  TAGS         = local.marketing_tags
  ENV          = var.ENV
  FEATURE_NAME = local.marketing_feature_name
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

module "read_write_dynamodb_lambda_role" {
  source = "../../modules/security/iam/role/lambda/read_write_dynamodb"

  TAGS         = local.base_backend_tags
  ENV          = var.ENV
  FEATURE_NAME = local.base_backend_name
  DYNAMO_TABLE_ARN = module.sale_chat_dynamodb.arn
}

module "base_backend_secret_manager" {
  source       = "../../modules/security/secret_manager"
  ENV          = var.ENV
  FEATURE_NAME = local.base_backend_name
  STORE_DATA = {
    "COGNITO_USER_POOL_ID"      = module.cognito_user_pool.id
    "COGNITO_CLIENT_ID"         = module.cognito_user_pool.client_ids[0]
    "TF_BUCKET"                 = var.TF_BUCKET
    "NOTIFICATION_SENDER_EMAIL" = "anh93.nguyentuan@gmail.com"
    "ADMIN_EMAIL"               = "anh93.nguyentuan@gmail.com"
  }
  TAGS = local.base_backend_tags
}
# Tenant infrastrucutre: END

# Marketing Infrastructure: START
module "marketing_vpc" {
  source                 = "../../modules/network/vpc"
  ENV                    = var.ENV
  FEATURE_NAME           = local.marketing_feature_name
  AWS_REGION             = var.AWS_REGION
  VPC_CIDR               = var.MARKETING_VPC_CIDR
  PUBLIC_SUBNETS_CIDR    = var.MARKETING_PUBLIC_SUBNETS_CIDR
  PRIVATE_SUBNETS_CIDR   = var.MARKETING_PRIVATE_SUBNETS_CIDR
  DATABASE_SUBNETS_CIDR  = var.MARKETING_DATABASE_SUBNETS_CIDR
  SINGLE_NAT_GATEWAY     = local.is_prod ? false : true
  ONE_NAT_GATEWAY_PER_AZ = local.is_prod ? true : false
  TAGS                   = local.marketing_tags
}

module "sale_frontend_pipeline" {
  source                         = "../../modules/cicd"
  ENV                            = var.ENV
  BRANCH_NAME                    = var.BRANCH_NAME
  CODESTAR_CONNECTOR_CREDENTIALS = var.CODESTAR_CONNECTOR_CREDENTIALS
  ENV_VARS                       = concat(local.code_build_env.common, local.code_build_env.sale_web)
  CODEPIPELINE_BUCKET            = var.CODEPIPELINE_BUCKET
  GITHUB_REPO                    = "TravelOffice/sale_web"
  FEATURE_NAME                   = local.sale_frontend_name
  TAGS                           = local.sale_frontend_tags
}

module "sale_frontend_hosting" {
  source        = "../../modules/hosting"
  BUCKET_PREFIX = "${var.ENV}-${local.sale_frontend_name}"
  ACM           = local.acm
  TAGS          = local.sale_frontend_tags
}

module "marketing_backend_pipeline" {
  source                         = "../../modules/cicd"
  ENV                            = var.ENV
  BRANCH_NAME                    = var.BRANCH_NAME
  CODESTAR_CONNECTOR_CREDENTIALS = var.CODESTAR_CONNECTOR_CREDENTIALS
  ENV_VARS                       = local.code_build_env.common
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

module "chat_appsync" {
  source               = "../../modules/application/appsync"
  AWS_REGION           = var.AWS_REGION
  ENV                  = var.ENV
  FEATURE_NAME         = local.marketing_feature_name
  COGNITO_USER_POOL_ID = module.cognito_user_pool.id
  ACM                  = local.acm
  HOSTED_ZONE_ID       = local.hosted_zone_id
  TAGS                 = local.marketing_tags
}

module "sale_chat_dynamodb" {
  source = "../../modules/database/dynamodb"
  ENV    = var.ENV
  TAGS   = local.marketing_tags
}
# Marketing Infrastructure: END