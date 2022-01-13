variable "ENV" {}
variable "FEATURE_NAME" {}
variable "STORE_DATA" {
  type = map(any)
}
variable "TAGS" {}

variable "RECOVERY_DAYS" {
  default = 0
}

# Now create secret and secret versions for database master account 
resource "aws_secretsmanager_secret" "secrets_manager" {
  name                    = "${var.ENV}-${var.FEATURE_NAME}-secret-keys"
  recovery_window_in_days = var.RECOVERY_DAYS
  tags                    = var.TAGS
}

resource "aws_secretsmanager_secret_version" "secret_manager_version" {
  secret_id     = aws_secretsmanager_secret.secrets_manager.id
  secret_string = jsonencode(var.STORE_DATA)
}

# Lets import the Secrets which got created recently and store it so that we can use later. 

data "aws_secretsmanager_secret" "secrets_manager" {
  arn = aws_secretsmanager_secret.secrets_manager.arn
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.secrets_manager.arn
}
