variable "ENV" {}
variable "FEATURE_NAME" {}
variable "COGNITO_USER_POOL_ID" {}
variable "AWS_REGION" {}
variable "SCHEMA_FILE" {
  default = "../../modules/application/appsync/schema.graphql"
}
variable "LOGGING_ENABLED" {
  default = true
}
variable "XRAY_ENABLED" {
  default = false
}
variable "LOG_LEVEL" {
  default = "ALL"
}
variable "ACM" {}
variable "DOMAIN_NAME" {
  default = "chat"
}
variable "HOSTED_ZONE_ID" {}
variable "TAGS" {}

module "appsync" {
  source  = "terraform-aws-modules/appsync/aws"
  version = "1.4.0"

  name = "${var.ENV}-${var.FEATURE_NAME}-appsync"

  schema = file("${var.SCHEMA_FILE}")

  api_keys = {
    default = null # such key will expire in 7 days
  }
  authentication_type = "AMAZON_COGNITO_USER_POOLS"
  user_pool_config = {
    aws_region     = var.AWS_REGION
    default_action = "ALLOW"
    user_pool_id   = var.COGNITO_USER_POOL_ID
  }
  logging_enabled                 = var.LOGGING_ENABLED
  xray_enabled                    = var.XRAY_ENABLED
  log_field_log_level             = var.LOG_LEVEL
  domain_name                     = "${var.DOMAIN_NAME}.traveloffice.shop"
  domain_name_association_enabled = true
  certificate_arn                 = var.ACM
  tags                            = var.TAGS
}

resource "aws_route53_record" "record" {
  zone_id = var.HOSTED_ZONE_ID
  name    = var.DOMAIN_NAME
  type    = "CNAME"
  ttl     = "300"
  records = [module.appsync.appsync_domain_name]
}

output "domain" {
  value = module.appsync.appsync_domain_id
}

output "id" {
  value = module.appsync.appsync_graphql_api_id
}