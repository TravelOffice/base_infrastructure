variable "ENV" {}
variable "AUTOSCALING_ENABLED" {
  default = false
}

variable "BILLING_MODE" {
  default = "PROVISIONED"
}
variable "WRITE_CAPACITY" {
  default = 1
}
variable "READ_CAPACITY" {
  default = 1
}
variable "TAGS" {}

module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name      = "${var.ENV}-sale_chat"
  hash_key  = "pk"
  range_key = "sk"

  attributes = [
    {
      name = "pk"
      type = "S"
    },
    {
      name = "sk"
      type = "S"
    }
  ]
  write_capacity      = var.WRITE_CAPACITY
  read_capacity       = var.READ_CAPACITY
  autoscaling_enabled = var.AUTOSCALING_ENABLED
  billing_mode        = var.BILLING_MODE
  tags                = var.TAGS
}

output "arn" {
  value = module.dynamodb_table.dynamodb_table_arn
}