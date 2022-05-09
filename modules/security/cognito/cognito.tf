variable "ENV" {}
variable "ALLOW_ADMIN_CREATE_USER_ONLY" {
  default = false
}
variable "MFA_CONFIGURATION" {
  default = "OFF"
}
variable "SMS_VERIFICATION_SUBJECT" {
  default = "Your verification code is {####}."
}
variable "ADMIN_CREATE_USER_CONFIG_SMS_MESSAGE" {
  default = "Your username is {username} and temporary password is {####}. If you do not log in within 7 days you'll need a new invite."
}
variable "SMS_AUTHENTICATION_MESSAGE" {
  default = "Your authentication code is {####}."
}
variable "EMAIL_VERIFICATION_SUBJECT" {
  default = "Your verification code"
}
variable "EMAIL_VERIFICATION_MESSAGE" {
  default = "{username}, your verification code is {####}."
}
variable "ADMIN_CREATE_USER_CONFIG_EMAIL_MESSAGE" {
  default = "Your username is {username} and temporary password is {####}"
}
variable "PASSWORD_POLICY" {
  default = {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }
}
variable "TAGS" {}


module "cognito_user_pool" {
  source                                                = "lgallard/cognito-user-pool/aws"
  version                                               = "0.15.2"
  user_pool_name                                        = "${var.ENV}-user-pool"
  password_policy                                       = var.PASSWORD_POLICY
  sms_verification_message                              = var.SMS_VERIFICATION_SUBJECT
  email_verification_subject                            = var.EMAIL_VERIFICATION_SUBJECT
  email_verification_message                            = var.EMAIL_VERIFICATION_MESSAGE
  admin_create_user_config_email_message                = var.ADMIN_CREATE_USER_CONFIG_EMAIL_MESSAGE
  admin_create_user_config_sms_message                  = var.ADMIN_CREATE_USER_CONFIG_SMS_MESSAGE
  mfa_configuration                                     = var.MFA_CONFIGURATION
  sms_authentication_message                            = var.SMS_AUTHENTICATION_MESSAGE
  admin_create_user_config_allow_admin_create_user_only = var.ALLOW_ADMIN_CREATE_USER_ONLY
  client_name                                           = "${var.ENV}-app-client"
  client_explicit_auth_flows                            = ["ALLOW_USER_SRP_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH"]
  client_prevent_user_existence_errors                  = "ENABLED"
  client_callback_urls                                  = ["http://localhost:3000"]
  client_default_redirect_uri                           = "http://localhost:3000"
  client_allowed_oauth_scopes                           = ["phone", "email", "openid", "profile"]
  client_allowed_oauth_flows                            = ["code", "implicit"]
  client_generate_secret                                = false
  tags                                                  = var.TAGS
  string_schemas = [
    {
      attribute_data_type      = "String"
      developer_only_attribute = false
      mutable                  = true
      name                     = "role"
      required                 = false
      string_attribute_constraints = {
        min_length = 0
        max_length = 100
      }
    }
  ]
}

output "id" {
  value = module.cognito_user_pool.id
}

output "client_ids" {
  value = module.cognito_user_pool.client_ids
}

output "arn" {
  value = module.cognito_user_pool.arn
}