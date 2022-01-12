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
variable "ALLOWED_SECURITY_GROUPS" {
  type    = list(any)
  default = []
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
  type    = map(any)
  default = {}
}
variable "MONITORING_INTERVAL" {
  default = 60
}
variable "LOG_TYPES" {
    default = "postgresql"
}

module "cluster" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name           = "${var.ENV}-${var.FEATURE_NAME}-aurora-db-postgresql"
  engine         = var.ENGINE
  engine_version = var.ENGINE_VERSION
  instance_class = var.INSTANCE_CLASS
  instances      = var.INSTANCES

  vpc_id  = var.VPC_ID
  subnets = var.DATABASE_SUBNETS

  allowed_security_groups = ["sg-12345678"]
  allowed_cidr_blocks     = ["10.20.0.0/20"]

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = var.MONITORING_INTERVAL

  db_parameter_group_name         = aws_db_parameter_group.postgresql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.postgresql.id

  enabled_cloudwatch_logs_exports = [var.LOG_TYPES]

  tags = {
    Environment = var.ENV
    Feature     = var.FEATURE_NAME
    Terraform   = "true"
  }
}

resource "aws_db_parameter_group" "postgresql" {
  name        = "${var.ENV}-${var.FEATURE_NAME}-aurora-db-postgres-parameter-group"
  family      = "aurora-postgresql13"
  description = "${var.ENV}-${var.FEATURE_NAME}-aurora-db-postgres-parameter-group"
#   tags        = local.tags
}

resource "aws_rds_cluster_parameter_group" "postgresql" {
  name        = "${var.ENV}-${var.FEATURE_NAME}-aurora-postgres-cluster-parameter-group"
  family      = "aurora-postgresql13"
  description = "${var.ENV}-${var.FEATURE_NAME}-aurora-postgres-cluster-parameter-group"
#   tags        = local.tags
}