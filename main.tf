data "aws_secretsmanager_secret" "secrets" {
  arn = var.SCM_CONSTANT_ARN
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

locals {
  constants                      = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)
  tf_version                     = local.constants["TF_VERSION"]
  fb_token                       = local.constants["FB_TOKEN"]
  fb_graph_endpoint              = local.constants["FB_GRAPH_ENDPOINT"]
  fb_client_id                   = local.constants["FB_CLIENT_ID"]
  fb_client_secret               = local.constants["FB_CLIENT_SECRET"]
  zalo_app_id                    = local.constants["ZALO_APP_ID"]
  zalo_secret_key                = local.constants["ZALO_SECRET_KEY"]
  hosted_zone_id                 = local.constants["HOSTED_ZONE_ID"]
  hosted_domain_name             = local.constants["HOSTED_DOMAIN_NAME"]
  cloudfront_acm                 = local.constants["CLOUDFRONT_ACM"]
  api_gateway_acm                = local.constants["API_GATEWAY_ACM"]
  marketing_backend              = "marketing-backend"
  sale_frontend                  = "sale-frontend"
  base_backend                   = "base-backend"
  mail_backend                   = "mail-backend"
  marketplace                    = "marketplace"
  encryption_secret_key          = local.constants["ENCRYPTION_SECRET_KEY"]
  codepipeline_bucket            = local.constants["CODEPIPELINE_BUCKET"]
  mail_cdn                       = local.constants["MAIL_CDN"]
  chat_cdn                       = local.constants["CHAT_CDN"]
  marketplace_cdn                = local.constants["MARKETPLACE_CDN"]
  tf_state_bucket                = local.constants["TF_STATE_BUCKET"]
  codestar_connector_credentials = local.constants["CODESTAR_CONNECTOR_CREDENTIALS"]
  firebase_credential            = local.constants["FIREBASE_CREDENTIAL"]

  marketing_tags = {
    Env       = var.ENV
    Terraform = true
    Feature   = local.marketing_backend
  }
  sale_frontend_tags = {
    Env       = var.ENV
    Terraform = true
    Feature   = local.sale_frontend
  }
  base_backend_tags = {
    Env       = var.ENV
    Terraform = true
    Feature   = local.base_backend
  }
  mail_tags = {
    Env       = var.ENV
    Terraform = true
    Feature   = local.mail_backend
  }
  marketplace_tags = {
    Env       = var.ENV
    Terraform = true
    Feature   = local.marketplace
  }
  is_prod = var.ENV == "prod"
  code_build_env = {
    common = [
      {
        name  = "TF_BUCKET"
        value = local.tf_state_bucket
      },
      {
        name  = "BUILD_ENV"
        value = var.ENV
      },
      {
        name  = "TF_VERSION"
        value = local.tf_version
      },
      {
        name  = "TF_LOG"
        value = var.TF_LOG
      }
    ],
    sale_web = [
      {
        name  = "REACT_APP_BASE_URL"
        value = "https://${var.ENV}-${local.marketing_backend}.${local.hosted_domain_name}"
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
        name  = "REACT_APP_LB_BASE_URL"
        value = "https://${module.loadbalancer.lb_endpoint}"
      },
      {
        name  = "REACT_APP_MARKETPLACE_PAGE"
        value = "https://${local.marketplace}.${local.hosted_domain_name}"
      },
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
  CODESTAR_CONNECTOR_CREDENTIALS = local.codestar_connector_credentials
  ENV_VARS                       = local.code_build_env.common
  CODEPIPELINE_BUCKET            = local.codepipeline_bucket
  GITHUB_REPO                    = "TravelOffice/base_backend"
  FEATURE_NAME                   = local.base_backend
  TAGS                           = local.base_backend_tags
}
/* module "base_backend_vpc" {
  source                 = "../../modules/network/vpc"
  ENV                    = var.ENV
  FEATURE_NAME           = local.base_backend
  AWS_REGION             = var.AWS_REGION
  VPC_CIDR               = var.BASE_BACKEND_VPC_CIDR
  PUBLIC_SUBNETS_CIDR    = var.BASE_BACKEND_PUBLIC_SUBNETS_CIDR
  PRIVATE_SUBNETS_CIDR   = var.BASE_BACKEND_PRIVATE_SUBNETS_CIDR
  SINGLE_NAT_GATEWAY     = local.is_prod ? false : true
  ONE_NAT_GATEWAY_PER_AZ = local.is_prod ? true : false
  TAGS                   = local.base_backend_tags
} */

/* resource "aws_security_group" "base_backend_lambda_sg" {
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
} */
module "provisioning_tenant_infra_ecs_task_role" {
  source = "../../modules/security/iam/role/ecs/task"

  TAGS         = local.base_backend_tags
  ENV          = var.ENV
  FEATURE_NAME = local.base_backend
}

module "base_backend_secret_manager" {
  source       = "../../modules/security/secret_manager"
  ENV          = var.ENV
  FEATURE_NAME = local.base_backend
  STORE_DATA = {
    "COGNITO_USER_POOL_ID"                     = module.cognito_user_pool.id
    "COGNITO_CLIENT_ID"                        = module.cognito_user_pool.client_id
    "TF_BUCKET"                                = local.tf_state_bucket
    "NOTIFICATION_SENDER_EMAIL"                = local.constants["NOTIFICATION_SENDER_EMAIL"]
    "ADMIN_EMAIL"                              = local.constants["ADMIN_EMAIL"]
    "DYNAMO_TRAVEL_TABLE"                      = module.travel_table_dynamodb.db_name
    "DYNAMO_MARKETPLACE_TABLE"                 = module.marketplace_table_dynamodb.db_name
    "DYNAMO_STATISTIC_TABLE"                   = module.statistic_table_dynamodb.db_name
    "DYNAMO_ROLE_PERMISSION_TABLE"             = module.role_permission_table_dynamodb.db_name
    "DYNAMO_MARKETPLACE_ROLE_PERMISSION_TABLE" = module.marketplace_role_permission_table_dynamodb.db_name
    "DYNAMO_NOTIFICATION_TABLE"                = module.notification_table_dynamodb.db_name
    "DOMAIN_NAME"                              = local.hosted_domain_name
  }
  TAGS = local.base_backend_tags
}
# Tenant infrastrucutre: END

# Marketing Infrastructure: START
module "marketing_vpc" {
  source                = "../../modules/network/vpc"
  ENV                   = var.ENV
  FEATURE_NAME          = local.marketing_backend
  AWS_REGION            = var.AWS_REGION
  VPC_CIDR              = var.MARKETING_VPC_CIDR
  PUBLIC_SUBNETS_CIDR   = var.MARKETING_PUBLIC_SUBNETS_CIDR
  PRIVATE_SUBNETS_CIDR  = var.MARKETING_PRIVATE_SUBNETS_CIDR
  DATABASE_SUBNETS_CIDR = var.MARKETING_DATABASE_SUBNETS_CIDR
  TAGS                  = local.marketing_tags
}

# Define the base loadblancer which use for all marketing backend
# We will use path based routing to distribute traffic to co response service
module "loadbalancer" {
  source        = "../../modules/network/loadbalancer"
  vpc_id        = module.marketing_vpc.id
  public_subnet = module.marketing_vpc.public_subnets
  domain_arn    = local.api_gateway_acm
  feature_name  = local.marketing_backend
  hosted_zone   = local.hosted_zone_id
  env           = var.ENV
  tags          = local.marketing_tags
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
  CODESTAR_CONNECTOR_CREDENTIALS = local.codestar_connector_credentials
  ENV_VARS                       = concat(local.code_build_env.common, local.code_build_env.sale_web)
  TF_PLAN_COMPUTE_TYPE           = "BUILD_GENERAL1_MEDIUM"
  CODEPIPELINE_BUCKET            = local.codepipeline_bucket
  GITHUB_REPO                    = "TravelOffice/sale_web"
  FEATURE_NAME                   = local.sale_frontend
  TAGS                           = local.sale_frontend_tags
}

module "sale_frontend_hosting" {
  source        = "../../modules/hosting"
  BUCKET_PREFIX = "${var.ENV}-${local.sale_frontend}"
  ACM           = local.cloudfront_acm
  ALIASES       = ["*.${local.hosted_domain_name}"]
  TAGS          = local.sale_frontend_tags
}

module "marketing_backend_pipeline" {
  source                         = "../../modules/cicd"
  ENV                            = var.ENV
  BRANCH_NAME                    = var.BRANCH_NAME
  CODESTAR_CONNECTOR_CREDENTIALS = local.codestar_connector_credentials
  ENV_VARS                       = local.code_build_env.common
  CODEPIPELINE_BUCKET            = local.codepipeline_bucket
  GITHUB_REPO                    = "TravelOffice/marketing_backend"
  FEATURE_NAME                   = local.marketing_backend
  TAGS                           = local.marketing_tags
}

module "marketing_secret_manager" {
  source       = "../../modules/security/secret_manager"
  ENV          = var.ENV
  FEATURE_NAME = local.marketing_backend
  STORE_DATA = {
    "CHAT_APPSYNC_API_KEY"                     = module.chat_appsync.api_key
    "CHAT_APPSYNC_GRAPHQL_ENDPOINT"            = module.chat_appsync.graphql_endpoint
    "CHAT_APPSYNC_REALTIME_ENDPOINT"           = module.chat_appsync.realtime_endpoint
    "DYNAMO_TRAVEL_TABLE"                      = module.travel_table_dynamodb.db_name
    "DYNAMO_CHAT_TABLE"                        = module.chat_table_dynamodb.db_name
    "DYNAMO_ROLE_PERMISSION_TABLE"             = module.role_permission_table_dynamodb.db_name
    "DYNAMO_MAIL_TABLE"                        = module.mail_table_dynamodb.db_name
    "DYNAMO_MARKETPLACE_TABLE"                 = module.marketplace_table_dynamodb.db_name
    "DYNAMO_STATISTIC_TABLE"                   = module.statistic_table_dynamodb.db_name
    "DYNAMO_MARKETPLACE_ROLE_PERMISSION_TABLE" = module.marketplace_role_permission_table_dynamodb.db_name
    "DYNAMO_NOTIFICATION_TABLE"                = module.notification_table_dynamodb.db_name
    "FB_MESSAGE_PLATFORM_VERIFY_TOKEN"         = local.fb_token
    "FB_GRAPH_ENDPOINT"                        = local.fb_graph_endpoint
    "FACEBOOK_CLIENT_ID"                       = local.fb_client_id
    "FACEBOOK_CLIENT_SECRET"                   = local.fb_client_secret
    "ZALO_MESSAGE_PLATFORM_APP_ID"             = local.zalo_app_id
    "ZALO_MESSAGE_PLATFORM_SECRET_KEY"         = local.zalo_secret_key
    "COGNITO_USER_POOL_ID"                     = module.cognito_user_pool.id
    "COGNITO_CLIENT_ID"                        = module.cognito_user_pool.client_id
    "CHAT_FILE_BUCKET"                         = module.sale_chat_attachment_bucket.id
    "CHAT_FILE_BUCKET_URL"                     = module.sale_chat_attachment_bucket.bucket_regional_domain_name
    "CHAT_FILE_CDN"                            = "https://${local.chat_cdn}"
    "MAIL_BUCKET"                              = module.mail_bucket.id
    "MAIL_BUCKET_URL"                          = module.mail_bucket.bucket_regional_domain_name
    "MAIL_CDN"                                 = "https://${local.mail_cdn}"
    "MARKETPLACE_FILE_BUCKET"                  = module.marketplace_attachment_bucket.id
    "MARKETPLACE_FILE_BUCKET_URL"              = module.marketplace_attachment_bucket.bucket_regional_domain_name
    "MARKETPLACE_FILE_CDN"                     = "https://${local.marketplace_cdn}"
    "MARKETPLACE_NOTIFICATION_SNS_TOPIC"       = module.system_notification_sns.topic_arn
    "NEW_CONVERSATION_QUEUE_ENDPOINT"          = module.queue.new_conversation_queue_url
    "ENCRYPT_SECRET_KEY"                       = local.encryption_secret_key
    "SEARCH_ENGINE_ENDPOINT"                   = "https://${module.loadbalancer.lb_endpoint}"
  }
  TAGS = local.marketing_tags
}

module "chat_appsync" {
  source               = "../../modules/application/appsync"
  AWS_REGION           = var.AWS_REGION
  ENV                  = var.ENV
  FEATURE_NAME         = local.marketing_backend
  COGNITO_USER_POOL_ID = module.cognito_user_pool.id
  ACM                  = local.cloudfront_acm
  HOSTED_ZONE_ID       = local.hosted_zone_id
  DOMAIN_NAME          = "${var.ENV}-appsync.${local.hosted_domain_name}"
  TAGS                 = local.marketing_tags
}

module "travel_table_dynamodb" {
  source                      = "../../modules/database/dynamodb/travel_table"
  ENV                         = var.ENV
  DB_NAME                     = "travel_table"
  TAGS                        = local.marketing_tags
  BILLING_MODE                = var.DYNAMO_BILLING_MODE
  AUTOSCALING_ENABLED         = var.DYNAMO_AUTOSCALING_ENABLED
  PITR                        = var.PITR
  WRITE_CAPACITY              = var.TRAVEL_WCU
  MAX_WRITE_CAPACITY          = var.TRAVEL_MAX_WCU
  READ_CAPACITY               = var.TRAVEL_RCU
  MAX_READ_CAPACITY           = var.TRAVEL_MAX_RCU
  DELETION_PROTECTION_ENABLED = var.DELETION_PROTECTION_ENABLED
}

module "chat_table_dynamodb" {
  source                      = "../../modules/database/dynamodb/chat_table"
  ENV                         = var.ENV
  DB_NAME                     = "chat_table"
  TAGS                        = local.marketing_tags
  BILLING_MODE                = var.DYNAMO_BILLING_MODE
  AUTOSCALING_ENABLED         = var.DYNAMO_AUTOSCALING_ENABLED
  WRITE_CAPACITY              = var.CHAT_WCU
  MAX_WRITE_CAPACITY          = var.CHAT_MAX_WCU
  READ_CAPACITY               = var.CHAT_RCU
  MAX_READ_CAPACITY           = var.CHAT_MAX_RCU
  DELETION_PROTECTION_ENABLED = var.DELETION_PROTECTION_ENABLED

}

module "marketplace_table_dynamodb" {
  source                      = "../../modules/database/dynamodb/marketplace_table"
  ENV                         = var.ENV
  DB_NAME                     = "marketplace_table"
  TAGS                        = local.marketing_tags
  BILLING_MODE                = var.DYNAMO_BILLING_MODE
  AUTOSCALING_ENABLED         = var.DYNAMO_AUTOSCALING_ENABLED
  PITR                        = var.PITR
  WRITE_CAPACITY              = var.MK_WCU
  MAX_WRITE_CAPACITY          = var.MK_MAX_WCU
  READ_CAPACITY               = var.MK_RCU
  MAX_READ_CAPACITY           = var.MK_MAX_RCU
  DELETION_PROTECTION_ENABLED = var.DELETION_PROTECTION_ENABLED

}

module "statistic_table_dynamodb" {
  source                      = "../../modules/database/dynamodb/statistic_table"
  ENV                         = var.ENV
  DB_NAME                     = "statistic_table"
  TAGS                        = local.marketing_tags
  BILLING_MODE                = var.DYNAMO_BILLING_MODE
  AUTOSCALING_ENABLED         = var.DYNAMO_AUTOSCALING_ENABLED
  PITR                        = var.PITR
  WRITE_CAPACITY              = var.STATISTIC_WCU
  MAX_WRITE_CAPACITY          = var.STATISTIC_MAX_WCU
  READ_CAPACITY               = var.STATISTIC_RCU
  MAX_READ_CAPACITY           = var.STATISTIC_MAX_RCU
  DELETION_PROTECTION_ENABLED = var.DELETION_PROTECTION_ENABLED
}

module "role_permission_table_dynamodb" {
  source                      = "../../modules/database/dynamodb/role_permission_table"
  ENV                         = var.ENV
  DB_NAME                     = "role_permission_table"
  TAGS                        = local.marketing_tags
  BILLING_MODE                = var.DYNAMO_BILLING_MODE
  AUTOSCALING_ENABLED         = var.DYNAMO_AUTOSCALING_ENABLED
  WRITE_CAPACITY              = var.ROLE_WCU
  MAX_WRITE_CAPACITY          = var.ROLE_MAX_WCU
  READ_CAPACITY               = var.ROLE_RCU
  MAX_READ_CAPACITY           = var.ROLE_MAX_RCU
  DELETION_PROTECTION_ENABLED = var.DELETION_PROTECTION_ENABLED
}

module "marketplace_role_permission_table_dynamodb" {
  source                      = "../../modules/database/dynamodb/role_permission_table"
  ENV                         = var.ENV
  DB_NAME                     = "marketplace_role_permission_table"
  TAGS                        = local.marketing_tags
  AUTOSCALING_ENABLED         = var.DYNAMO_AUTOSCALING_ENABLED
  WRITE_CAPACITY              = var.MK_ROLE_WCU
  MAX_WRITE_CAPACITY          = var.MK_ROLE_MAX_WCU
  READ_CAPACITY               = var.MK_ROLE_RCU
  MAX_READ_CAPACITY           = var.MK_ROLE_MAX_RCU
  DELETION_PROTECTION_ENABLED = var.DELETION_PROTECTION_ENABLED
}

module "notification_table_dynamodb" {
  source                      = "../../modules/database/dynamodb/notification_table"
  ENV                         = var.ENV
  DB_NAME                     = "notification_table"
  TAGS                        = local.marketing_tags
  AUTOSCALING_ENABLED         = var.DYNAMO_AUTOSCALING_ENABLED
  WRITE_CAPACITY              = var.NOTIFICATION_WCU
  MAX_WRITE_CAPACITY          = var.NOTIFICATION_MAX_WCU
  READ_CAPACITY               = var.NOTIFICATION_RCU
  MAX_READ_CAPACITY           = var.NOTIFICATION_MAX_RCU
  DELETION_PROTECTION_ENABLED = var.DELETION_PROTECTION_ENABLED
}

module "mail_pipeline" {
  source                         = "../../modules/cicd"
  ENV                            = var.ENV
  BRANCH_NAME                    = var.BRANCH_NAME
  CODESTAR_CONNECTOR_CREDENTIALS = local.codestar_connector_credentials
  ENV_VARS                       = local.code_build_env.common
  CODEPIPELINE_BUCKET            = local.codepipeline_bucket
  GITHUB_REPO                    = "TravelOffice/mail"
  FEATURE_NAME                   = local.mail_backend
  TAGS                           = local.mail_tags
}

module "mail_table_dynamodb" {
  source                      = "../../modules/database/dynamodb/mail_table"
  ENV                         = var.ENV
  DB_NAME                     = "mail_table"
  TAGS                        = local.marketing_tags
  AUTOSCALING_ENABLED         = var.DYNAMO_AUTOSCALING_ENABLED
  WRITE_CAPACITY              = var.MAIL_WCU
  MAX_WRITE_CAPACITY          = var.MAIL_MAX_WCU
  READ_CAPACITY               = var.MAIL_RCU
  MAX_READ_CAPACITY           = var.MAIL_MAX_RCU
  DELETION_PROTECTION_ENABLED = var.DELETION_PROTECTION_ENABLED
}

module "sale_chat_attachment_bucket" {
  source        = "../../modules/storage/s3"
  BUCKET_PREFIX = "${var.ENV}-${local.sale_frontend}-attachments"
  TAGS          = local.marketing_tags
}

module "sale_chat_cdn" {
  source              = "../../modules/cdn"
  S3_BUCKET           = module.sale_chat_attachment_bucket
  ACM                 = local.cloudfront_acm
  ALIASES             = [local.chat_cdn]
  HOSTED_ZONE_ID      = local.hosted_zone_id
  DEFAULT_ROOT_OBJECT = ""
  RECORD_NAME         = "chatcdn"
  CUSTOM_HEADER_ID    = aws_cloudfront_response_headers_policy.custom_header.id
  TAGS                = local.marketing_tags
}

module "mail_bucket" {
  source            = "../../modules/storage/s3"
  BUCKET_PREFIX     = "${var.ENV}-mail"
  ENABLE_VERSIONING = "Suspended"
  TAGS              = local.marketing_tags
}

module "mail_cdn" {
  source              = "../../modules/cdn"
  S3_BUCKET           = module.mail_bucket
  ACM                 = local.cloudfront_acm
  ALIASES             = [local.mail_cdn]
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

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.marketing_vpc.id
  service_name = "com.amazonaws.${var.AWS_REGION}.s3"
  tags         = local.marketing_tags
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = module.marketing_vpc.id
  service_name = "com.amazonaws.${var.AWS_REGION}.dynamodb"
  tags         = local.marketing_tags
}

// Use for store user data of ec2 instance
module "script_bucket" {
  source            = "../../modules/storage/s3"
  BUCKET_PREFIX     = "${var.ENV}-${local.marketing_backend}-scripts"
  ENABLE_VERSIONING = "Suspended"
  TAGS              = local.marketing_tags
}
// Use for travel connect notification
module "system_subscribe_sqs" {
  source = "../../modules/fanout/sqs"
  NAME   = "system-subscribe-to-fcm-topic"
  ENV    = var.ENV
  TAGS   = local.marketplace_tags
}
module "system_subscribe_sns" {
  source                = "../../modules/fanout/sns"
  SNS_TOPIC_NAME        = "system-subscribe-to-fcm-topic"
  SUBSCRIPTION_ENDPOINT = module.system_subscribe_sqs.arn
  ENV                   = var.ENV
  TAGS                  = local.marketplace_tags
}
module "system_unsubscribe_sqs" {
  source = "../../modules/fanout/sqs"
  NAME   = "system-unsubscribe-from-fcm-topic"
  ENV    = var.ENV
  TAGS   = local.marketplace_tags
}
module "system_unsubscribe_sns" {
  source                = "../../modules/fanout/sns"
  SNS_TOPIC_NAME        = "system-unsubscribe-from-fcm-topic"
  SUBSCRIPTION_ENDPOINT = module.system_unsubscribe_sqs.arn
  ENV                   = var.ENV
  TAGS                  = local.marketplace_tags
}
module "system_notification_sqs" {
  source = "../../modules/fanout/sqs"
  NAME   = "system-notification"
  ENV    = var.ENV
  TAGS   = local.marketplace_tags
}
module "system_notification_sns" {
  source                = "../../modules/fanout/sns"
  SNS_TOPIC_NAME        = "system-notification"
  SUBSCRIPTION_ENDPOINT = module.system_notification_sqs.arn
  ENV                   = var.ENV
  TAGS                  = local.marketplace_tags
}
# Marketing Infrastructure: END

# Marketplace web
module "marketplace_attachment_bucket" {
  source        = "../../modules/storage/s3"
  BUCKET_PREFIX = "${var.ENV}-${local.marketplace}-attachments"
  TAGS          = local.marketplace_tags
}

module "marketplace_cdn" {
  source              = "../../modules/cdn"
  S3_BUCKET           = module.marketplace_attachment_bucket
  ACM                 = local.cloudfront_acm
  ALIASES             = [local.marketplace_cdn]
  HOSTED_ZONE_ID      = local.hosted_zone_id
  DEFAULT_ROOT_OBJECT = ""
  RECORD_NAME         = "marketplacecdn"
  CUSTOM_HEADER_ID    = aws_cloudfront_response_headers_policy.custom_header.id
  TAGS                = local.marketplace_tags
  depends_on          = [module.marketplace_attachment_bucket]
}
