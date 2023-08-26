variable "ENV" {}
variable "AWS_REGION" {}
variable "VPC_CIDR" {}
variable "FEATURE_NAME" {}
variable "PRIVATE_SUBNETS_CIDR" {
  default = []
}
variable "PUBLIC_SUBNETS_CIDR" {
  default = []
}
variable "DATABASE_SUBNETS_CIDR" {
  default = []
}
variable "ENABLE_NAT_GATEWAY" {
  default = true
}

variable "TAGS" {}

module "VPC" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "5.1.1"
  name                 = "${var.ENV}-${var.FEATURE_NAME}-vpc"
  cidr                 = var.VPC_CIDR
  azs                  = ["${var.AWS_REGION}a", "${var.AWS_REGION}b"]
  private_subnets      = var.PRIVATE_SUBNETS_CIDR
  public_subnets       = var.PUBLIC_SUBNETS_CIDR
  database_subnets     = var.DATABASE_SUBNETS_CIDR
  enable_nat_gateway   = var.ENABLE_NAT_GATEWAY
  single_nat_gateway   = true
  enable_dhcp_options  = true
  enable_dns_hostnames = true

  tags = var.TAGS
}

output "id" {
  description = "The ID of the VPC"
  value       = module.VPC.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.VPC.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.VPC.public_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.VPC.database_subnets
}
