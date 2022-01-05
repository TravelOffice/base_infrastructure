variable "SYSTEM" {}
variable "ENV" {}
variable "AWS_REGION" {}
variable "VPC_CIDR" {}
variable "PREFIX" {
  default = "CBCB"
}
variable "PRIVATE_SUBNETS" {}
variable "PUBLIC_SUBNETS" {}
variable "DATABASE_SUBNETS" {}

module "VPC" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.PREFIX}-${var.ENV}-vpc"
  cidr = var.VPC_CIDR
  azs             = ["${var.AWS_REGION}a", "${var.AWS_REGION}b"]
  private_subnets = var.PRIVATE_SUBNETS
  public_subnets  = var.PUBLIC_SUBNETS
  database_subnets = var.DATABASE_SUBNETS
  enable_nat_gateway = false
  enable_dhcp_options = true
  enable_dns_hostnames = true

  tags = {
    Terraform   = true
    Environment = var.ENV
    SYSTEM = var.SYSTEM
  }
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
