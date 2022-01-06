module "ROOT_VPC" {
  source                = "../../modules/network/vpc"
  ENV                   = var.ENV
  PREFIX                = var.PREFIX
  AWS_REGION            = var.AWS_REGION
  VPC_CIDR              = var.VPC_CIDR
  PUBLIC_SUBNETS_CIDR   = var.PUBLIC_SUBNETS_CIDR
  PRIVATE_SUBNETS_CIDR  = var.PRIVATE_SUBNETS_CIDR
  DATABASE_SUBNETS_CIDR = var.DATABASE_SUBNETS_CIDR
}

module "BACKEND_PIPELINE" {
  source      = "../../modules/cicd/backend"
  ENV         = var.ENV
  BRANCH_NAME = var.BRANCH_NAME
  CODESTAR_CONNECTOR_CREDENTIALS = var.CODESTAR_CONNECTOR_CREDENTIALS
}