variable "ENV" {}
variable "ALLOW_ADMIN_CREATE_USER_ONLY" {
  default = false
}
variable "MFA_CONFIGURATION" {
  default = "OFF"
}
variable "SMS_VERIFICATION_SUBJECT" {
  default = "Mã xác thực của bạn là: {####}."
}
variable "ADMIN_CREATE_USER_CONFIG_SMS_MESSAGE" {
  default = "Chúc mừng bạn! Hệ thống đã kích hoạt thành công tài khoản TravelOffice. Username: {username}, Password: {####}"
}
variable "SMS_AUTHENTICATION_MESSAGE" {
  default = "<p>Mã xác thực của bạn là: <strong>{####}</strong></p>"
}
variable "EMAIL_VERIFICATION_SUBJECT" {
  default = "Đổi mật khẩu tài khoản TravelOffice"
}
variable "EMAIL_VERIFICATION_MESSAGE" {
  default = "<p>Mã xác thực của bạn là: <strong>{####}</strong></p>"
}
variable "ADMIN_CREATE_USER_CONFIG_EMAIL_SUBJECT" {
  default = "Kích hoạt tài khoản TravelOffice"
}
variable "ADMIN_CREATE_USER_CONFIG_EMAIL_MESSAGE" {
  default = "<p>Chúc mừng bạn! Hệ thống đã kích hoạt thành công tài khoản TravelOffice</p><p>Username: <strong>{username}</strong></p><p>Password: <strong>{####}</strong></p>"
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
