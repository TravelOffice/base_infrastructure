variable "SCM_CONSTANT_ARN" {
  default = "arn:aws:secretsmanager:ap-southeast-1:087112488386:secret:dev-infrastructure-constant-91TPFe"
}

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
  firebase_credential            = jsondecode(local.constants["FIREBASE_CREDENTIAL"])

}

module "marketing_secret_manager" {
  source       = "../modules/security/secret_manager"
  ENV          = "dev"
  FEATURE_NAME = "json-scm-test"
  STORE_DATA = {
    "FB_MESSAGE_PLATFORM_VERIFY_TOKEN" = local.fb_token
    "ENCRYPT_SECRET_KEY"               = local.encryption_secret_key
    "FIREBASE_CREDENTIAL"              = jsonencode(local.firebase_credential)
  }
  TAGS = {}
}
