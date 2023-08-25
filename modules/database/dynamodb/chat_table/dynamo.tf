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
variable "MAX_WRITE_CAPACITY" {
  default = 5
}
variable "MIN_WRITE_CAPACITY" {
  default = 5
}
variable "READ_CAPACITY" {
  default = 1
}
variable "MAX_READ_CAPACITY" {
  default = 10
}
variable "MIN_READ_CAPACITY" {
  default = 5
}

variable "TAGS" {}
variable "DB_NAME" {}

locals {
  is_ondemand = var.BILLING_MODE == "PAY_PER_REQUEST"
}
module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "1.2.2"

  name      = "${var.ENV}-${var.DB_NAME}"
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
    },
    {
      name = "lsi1"
      type = "S"
    },
    {
      name = "lsi2"
      type = "S"
    },
    {
      name = "lsi3"
      type = "S"
    },
    {
      name = "lsi4"
      type = "S"
    },
    {
      name = "lsi5"
      type = "S"
    }
  ]

  local_secondary_indexes = [
    {
      name               = "Index1"
      projection_type    = "ALL"
      range_key          = "lsi1"
      non_key_attributes = []
    },
    {
      name               = "Index2"
      projection_type    = "ALL"
      range_key          = "lsi2"
      non_key_attributes = []
    },
    {
      name               = "Index3"
      projection_type    = "ALL"
      range_key          = "lsi3"
      non_key_attributes = []
    },
    {
      name               = "Index4"
      projection_type    = "ALL"
      range_key          = "lsi4"
      non_key_attributes = []
    },
    {
      name               = "Index5"
      projection_type    = "ALL"
      range_key          = "lsi5"
      non_key_attributes = []
    }
  ]

  global_secondary_indexes = [
    {
      hash_key           = "sk"
      range_key          = "pk"
      name               = "ReverseIndex"
      non_key_attributes = []
      projection_type    = "ALL"
      read_capacity      = local.is_ondemand ? null : var.READ_CAPACITY
      write_capacity     = local.is_ondemand ? null : var.WRITE_CAPACITY
    },
    {
      hash_key           = "lsi1"
      range_key          = "pk"
      name               = "ConversationAsssigneeIndex"
      non_key_attributes = []
      projection_type    = "KEYS_ONLY"
      read_capacity      = local.is_ondemand ? null : var.READ_CAPACITY
      write_capacity     = local.is_ondemand ? null : var.WRITE_CAPACITY
    },
  ]
  write_capacity = local.is_ondemand ? null : var.WRITE_CAPACITY
  read_capacity  = local.is_ondemand ? null : var.READ_CAPACITY

  autoscaling_write = {
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
    target_value       = 70
    max_capacity       = var.MIN_WRITE_CAPACITY
  }

  autoscaling_read = {
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
    target_value       = 70
    max_capacity       = var.MIN_READ_CAPACITY
  }
  autoscaling_indexes = {
    ConversationAsssigneeIndex = {
      read_max_capacity  = var.MAX_READ_CAPACITY
      read_min_capacity  = var.MIN_READ_CAPACITY
      write_max_capacity = var.MAX_READ_CAPACITY
      write_min_capacity = var.MIN_WRITE_CAPACITY
    }
    ReverseIndex = {
      read_max_capacity  = var.MAX_READ_CAPACITY
      read_min_capacity  = var.MIN_READ_CAPACITY
      write_max_capacity = var.MAX_READ_CAPACITY
      write_min_capacity = var.MIN_WRITE_CAPACITY
    }
  }
  // ttl config
  ttl_enabled        = true
  ttl_attribute_name = "ttl"

  autoscaling_enabled = var.AUTOSCALING_ENABLED
  billing_mode        = var.BILLING_MODE
  tags                = var.TAGS
}

output "arn" {
  value = module.dynamodb_table.dynamodb_table_arn
}

output "db_name" {
  value = "${var.ENV}-${var.DB_NAME}"
}
