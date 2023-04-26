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
variable "ADMIN_CREATE_USER_CONFIG_EMAIL_SUBJECT" {
  default = "iTab Account"
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
variable "ID_TOKEN_EXPIRATION" {
  default = 12
}
variable "TAGS" {}

resource "aws_cognito_user_pool" "pool" {
  name = "${var.ENV}-user-pool"
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }
  sms_verification_message   = var.SMS_VERIFICATION_SUBJECT
  email_verification_subject = var.EMAIL_VERIFICATION_SUBJECT
  email_verification_message = var.EMAIL_VERIFICATION_MESSAGE
  admin_create_user_config {
    allow_admin_create_user_only = var.ALLOW_ADMIN_CREATE_USER_ONLY
    invite_message_template {
      email_subject = var.ADMIN_CREATE_USER_CONFIG_EMAIL_SUBJECT
      email_message = var.ADMIN_CREATE_USER_CONFIG_EMAIL_MESSAGE
      sms_message   = var.ADMIN_CREATE_USER_CONFIG_SMS_MESSAGE
    }

  }
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }
  mfa_configuration          = var.MFA_CONFIGURATION
  sms_authentication_message = var.SMS_AUTHENTICATION_MESSAGE
  tags                       = var.TAGS
}

resource "aws_cognito_user_pool_client" "client" {
  name                          = "${var.ENV}-app-client"
  user_pool_id                  = aws_cognito_user_pool.pool.id
  explicit_auth_flows           = ["ALLOW_USER_SRP_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH"]
  prevent_user_existence_errors = "ENABLED"
  callback_urls                 = ["http://localhost:3000"]
  default_redirect_uri          = "http://localhost:3000"
  allowed_oauth_scopes          = ["phone", "email", "openid", "profile"]
  allowed_oauth_flows           = ["code", "implicit"]
  generate_secret               = false
  id_token_validity             = var.ID_TOKEN_EXPIRATION
}

output "id" {
  value = aws_cognito_user_pool.pool.id
}

output "client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "arn" {
  value = aws_cognito_user_pool.pool.arn
}
