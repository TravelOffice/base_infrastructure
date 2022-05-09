variable "ENV" {
  type = string
}
variable "FEATURE_NAME" {
  type    = string
  default = ""
}
variable "INSTANCE_CLASS" {
  type    = string
  default = "db.t4g.medium"
}
variable "VPC_ID" {
  type = string
}
variable "DATABASE_SUBNETS" {
  type = list(any)
}
variable "ALLOWED_CIDR_BLOCKS" {
  type = list(any)
}
variable "ENGINE_VERSION" {
  default = "13.4"
}
variable "ENGINE" {
  default = "aurora-postgresql"
}
variable "INSTANCES" {
  type = map(any)
  default = {
    master = {}
  }
}
variable "MONITORING_INTERVAL" {
  default = 60
}
variable "LOG_TYPES" {
  default = "postgresql"
}
variable "USERNAME" {}
variable "DATABASE_NAME" {}
variable "RANDOM_PASSWORD_LENGTH" {
  default = 32
}
variable "ENGINE_MODE" {
  default = "provisioned"
}
variable "FAMILY" {
  default = "aurora-postgresql13"
}
variable "TAGS" {}
# Attribute for Serverless mode
variable "MIN_CAPACITY" {
  default = 2
}
variable "MAX_CAPACITY" {
  default = 4
}
variable "SECONDS_UNTIL_AUTO_PAUSE" {
  default = 300
}

locals {
  is_serverless = var.ENGINE_MODE == "serverless"
}

module "cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.1.0"

  name           = "${var.ENV}-${var.FEATURE_NAME}-aurora-db-postgresql"
  engine         = var.ENGINE
  engine_version = var.ENGINE_VERSION
  engine_mode    = var.ENGINE_MODE
  instance_class = local.is_serverless ? null : var.INSTANCE_CLASS
  instances      = local.is_serverless ? null : var.INSTANCES

  vpc_id  = var.VPC_ID
  subnets = var.DATABASE_SUBNETS

  allowed_cidr_blocks = var.ALLOWED_CIDR_BLOCKS

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = var.MONITORING_INTERVAL

  db_parameter_group_name         = aws_db_parameter_group.postgresql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.postgresql.id

  enabled_cloudwatch_logs_exports = local.is_serverless ? null : [var.LOG_TYPES]

  master_username        = var.USERNAME
  random_password_length = var.RANDOM_PASSWORD_LENGTH

  database_name       = var.DATABASE_NAME
  skip_final_snapshot = true

  tags = var.TAGS

  scaling_configuration = local.is_serverless ? {
    auto_pause               = true
    min_capacity             = var.MIN_CAPACITY
    max_capacity             = var.MAX_CAPACITY
    seconds_until_auto_pause = var.SECONDS_UNTIL_AUTO_PAUSE
    timeout_action           = "ForceApplyCapacityChange"
  } : null
}

resource "aws_db_parameter_group" "postgresql" {
  name        = "${var.ENV}-${var.FEATURE_NAME}-aurora-db-postgres-parameter-group"
  family      = var.FAMILY
  description = "${var.ENV}-${var.FEATURE_NAME}-aurora-db-postgres-parameter-group"
  tags        = var.TAGS
}

resource "aws_rds_cluster_parameter_group" "postgresql" {
  name        = "${var.ENV}-${var.FEATURE_NAME}-aurora-postgres-cluster-parameter-group"
  family      = var.FAMILY
  description = "${var.ENV}-${var.FEATURE_NAME}-aurora-postgres-cluster-parameter-group"
  tags        = var.TAGS
}

output "writer_endpoint" {
  value = module.cluster.cluster_endpoint
}

output "reader_endpoint" {
  value = module.cluster.cluster_reader_endpoint
}

output "port" {
  value = module.cluster.cluster_port
}

output "cluster_password" {
  value = module.cluster.cluster_master_password
}