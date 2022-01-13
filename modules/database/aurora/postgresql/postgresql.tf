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
variable "TAGS" {}

module "cluster" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name           = "${var.ENV}-${var.FEATURE_NAME}-aurora-db-postgresql"
  engine         = var.ENGINE
  engine_version = var.ENGINE_VERSION
  instance_class = var.INSTANCE_CLASS
  instances      = var.INSTANCES

  vpc_id  = var.VPC_ID
  subnets = var.DATABASE_SUBNETS

  allowed_cidr_blocks = var.ALLOWED_CIDR_BLOCKS

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = var.MONITORING_INTERVAL

  db_parameter_group_name         = aws_db_parameter_group.postgresql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.postgresql.id

  enabled_cloudwatch_logs_exports = [var.LOG_TYPES]

  master_username        = var.USERNAME
  random_password_length = var.RANDOM_PASSWORD_LENGTH

  database_name = var.DATABASE_NAME

  tags = var.TAGS
}

resource "aws_db_parameter_group" "postgresql" {
  name        = "${var.ENV}-${var.FEATURE_NAME}-aurora-db-postgres-parameter-group"
  family      = "aurora-postgresql13"
  description = "${var.ENV}-${var.FEATURE_NAME}-aurora-db-postgres-parameter-group"
  tags        = var.TAGS
}

resource "aws_rds_cluster_parameter_group" "postgresql" {
  name        = "${var.ENV}-${var.FEATURE_NAME}-aurora-postgres-cluster-parameter-group"
  family      = "aurora-postgresql13"
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