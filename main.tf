locals {
  fb_token               = "1CDFFB13226C9AC1C58D2F59D8B65"
  fb_graph_endpoint      = "https://graph.facebook.com/v13.0"
  fb_client_id           = "636976117412979"
  fb_client_secret       = "f34df5c9c4609da6f354db565229d67e"
  zalo_app_id            = "1364765243717231492"
  zalo_secret_key        = "N2Mh4JDI2IETV1IW9U24"
  hosted_zone_id         = "Z0837421MRKFPV1O1ZCI"
  hosted_domain_name     = "traveloffice.shop"
  acm                    = "arn:aws:acm:us-east-1:249593777629:certificate/20027980-d231-448a-930d-b37a515342dd"
  marketing_feature_name = "marketing-backend"
  sale_frontend_name     = "sale-frontend"
  base_backend_name      = "base-backend"
  mail_feature_name      = "mail-backend"
  encryption_secret_key  = "dAt$bAsE9#765@32"

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
  mail_tags = {
    Env       = var.ENV
    Terraform = true
    Feature   = local.mail_feature_name
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
        value = "https://${var.ENV}-${local.marketing_feature_name}.${local.hosted_domain_name}"
      },
      {
        name  = "REACT_APP_SSO_PAGE"
        value = "https://sso.${local.hosted_domain_name}"
      },
      {
        name  = "REACT_APP_APPSYNC_API_ENDPOINT"
        value = "https://${module.chat_appsync.domain}/graphql"
      },
      {
        name  = "REACT_APP_AWS_REGION"
        value = var.AWS_REGION
      },
      {
        name  = "REACT_APP_APPSYNC_REALTIME_ENDPOINT"
        value = "wss://${module.chat_appsync.domain}/graphql/realtime"
      },
      {
        name  = "REACT_APP_FACEBOOK_APP_ID"
        value = local.fb_client_id
      },
      {
        name  = "REACT_APP_MAIL_API_ENDPOINT"
        value = "https://${var.ENV}-mail.${local.hosted_domain_name}"
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

resource "aws_security_group" "base_backend_lambda_sg" {
  name_prefix = "lambda_sg"
  description = "Allow all outbound traffic"
  vpc_id      = module.base_backend_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = local.base_backend_tags
}
module "provisioning_tenant_infra_ecs_task_role" {
  source = "../../modules/security/iam/role/ecs/task"

  TAGS         = local.base_backend_tags
  ENV          = var.ENV
  FEATURE_NAME = local.base_backend_name
}

module "base_backend_secret_manager" {
  source       = "../../modules/security/secret_manager"
  ENV          = var.ENV
  FEATURE_NAME = local.base_backend_name
  STORE_DATA = {
    "COGNITO_USER_POOL_ID"         = module.cognito_user_pool.id
    "COGNITO_CLIENT_ID"            = module.cognito_user_pool.client_ids[0]
    "TF_BUCKET"                    = var.TF_BUCKET
    "NOTIFICATION_SENDER_EMAIL"    = "anh93.nguyentuan@gmail.com"
    "ADMIN_EMAIL"                  = "anh93.nguyentuan@gmail.com"
    "DYNAMO_TRAVEL_TABLE"          = module.travel_table_dynamodb.db_name
    "DYNAMO_ROLE_PERMISSION_TABLE" = module.role_permission_table_dynamodb.db_name
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

resource "aws_security_group" "marketing_lambda_sg" {
  name_prefix = "lambda_sg"
  description = "Allow all outbound traffic"
  vpc_id      = module.marketing_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = local.marketing_tags
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
  ALIASES       = ["*.traveloffice.shop"]
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

module "marketing_secret_manager" {
  source       = "../../modules/security/secret_manager"
  ENV          = var.ENV
  FEATURE_NAME = local.marketing_feature_name
  STORE_DATA = {
    "CHAT_APPSYNC_API_KEY"             = module.chat_appsync.api_key
    "CHAT_APPSYNC_GRAPHQL_ENDPOINT"    = module.chat_appsync.graphql_endpoint
    "CHAT_APPSYNC_REALTIME_ENDPOINT"   = module.chat_appsync.realtime_endpoint
    "DYNAMO_TRAVEL_TABLE"              = module.travel_table_dynamodb.db_name
    "DYNAMO_CHAT_TABLE"                = module.chat_table_dynamodb.db_name
    "DYNAMO_ROLE_PERMISSION_TABLE"     = module.role_permission_table_dynamodb.db_name
    "DYNAMO_MAIL_TABLE"                = module.mail_table_dynamodb.db_name
    "FB_MESSAGE_PLATFORM_VERIFY_TOKEN" = local.fb_token
    "FB_GRAPH_ENDPOINT"                = local.fb_graph_endpoint
    "FACEBOOK_CLIENT_ID"               = local.fb_client_id
    "FACEBOOK_CLIENT_SECRET"           = local.fb_client_secret
    "ZALO_MESSAGE_PLATFORM_APP_ID"     = local.zalo_app_id
    "ZALO_MESSAGE_PLATFORM_SECRET_KEY" = local.zalo_secret_key
    "COGNITO_USER_POOL_ID"             = module.cognito_user_pool.id
    "COGNITO_CLIENT_ID"                = module.cognito_user_pool.client_ids[0]
    "CHAT_FILE_BUCKET"                 = module.sale_chat_attachment_bucket.id
    "CHAT_FILE_BUCKET_URL"             = module.sale_chat_attachment_bucket.bucket_regional_domain_name
    "CHAT_FILE_CDN"                    = "https://${var.CHAT_CDN}"
    "MAIL_BUCKET"                      = module.mail_bucket.id
    "MAIL_BUCKET_URL"                  = module.mail_bucket.bucket_regional_domain_name
    "MAIL_CDN"                         = "https://${var.MAIL_CDN}"
    "NEW_CONVERSATION_QUEUE_ENDPOINT"  = module.queue.new_conversation_queue_url
    "ENCRYPT_SECRET_KEY"               = local.encryption_secret_key
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

module "travel_table_dynamodb" {
  source  = "../../modules/database/dynamodb/travel_table"
  ENV     = var.ENV
  DB_NAME = "travel_table"
  TAGS    = local.marketing_tags
}

module "chat_table_dynamodb" {
  source  = "../../modules/database/dynamodb/chat_table"
  ENV     = var.ENV
  DB_NAME = "chat_table"
  TAGS    = local.marketing_tags
}

module "role_permission_table_dynamodb" {
  source  = "../../modules/database/dynamodb/role_permission_table"
  ENV     = var.ENV
  DB_NAME = "role_permission_table"
  TAGS    = local.marketing_tags
}

module "mail_pipeline" {
  source                         = "../../modules/cicd"
  ENV                            = var.ENV
  BRANCH_NAME                    = var.BRANCH_NAME
  CODESTAR_CONNECTOR_CREDENTIALS = var.CODESTAR_CONNECTOR_CREDENTIALS
  ENV_VARS                       = local.code_build_env.common
  CODEPIPELINE_BUCKET            = var.CODEPIPELINE_BUCKET
  GITHUB_REPO                    = "TravelOffice/mail"
  FEATURE_NAME                   = local.mail_feature_name
  TAGS                           = local.mail_tags
}

module "mail_table_dynamodb" {
  source  = "../../modules/database/dynamodb/mail_table"
  ENV     = var.ENV
  DB_NAME = "mail_table"
  TAGS    = local.marketing_tags
}

module "sale_chat_attachment_bucket" {
  source              = "../../modules/storage/s3"
  BUCKET_PREFIX       = "${var.ENV}-${local.sale_frontend_name}-attachments"
  BLOCK_PUBLIC_ACCESS = true
  TAGS                = local.marketing_tags
}

module "sale_chat_cdn" {
  source              = "../../modules/cdn"
  S3_BUCKET           = module.sale_chat_attachment_bucket
  ACM                 = local.acm
  ALIASES             = [var.CHAT_CDN]
  HOSTED_ZONE_ID      = local.hosted_zone_id
  DEFAULT_ROOT_OBJECT = ""
  RECORD_NAME         = "chatcdn"
  CUSTOM_HEADER_ID    = aws_cloudfront_response_headers_policy.custom_header.id
  TAGS                = local.marketing_tags
}

module "mail_bucket" {
  source              = "../../modules/storage/s3"
  BUCKET_PREFIX       = "${var.ENV}-mail"
  BLOCK_PUBLIC_ACCESS = true
  ENABLE_VERSIONING   = "Suspended"
  TAGS                = local.marketing_tags
}

module "mail_cdn" {
  source              = "../../modules/cdn"
  S3_BUCKET           = module.mail_bucket
  ACM                 = local.acm
  ALIASES             = [var.MAIL_CDN]
  HOSTED_ZONE_ID      = local.hosted_zone_id
  DEFAULT_ROOT_OBJECT = ""
  RECORD_NAME         = "mailcdn"
  CUSTOM_HEADER_ID    = aws_cloudfront_response_headers_policy.custom_header.id
  TAGS                = local.marketing_tags
}

module "queue" {
  source = "../../modules/application/queue"
  ENV    = var.ENV
  TAGS   = local.marketing_tags
}

resource "aws_cloudfront_response_headers_policy" "custom_header" {
  name = "cache-control-headers-policy"

  custom_headers_config {
    items {
      header   = "Cache-Control"
      override = true
      value    = "private, max-age=31536000, immutable"
    }
  }
}

module "search" {
  source     = "../../modules/search"
  AWS_REGION = var.AWS_REGION
  ENV        = var.ENV
  TAGS       = local.marketing_tags
}

# Marketing Infrastructure: END
