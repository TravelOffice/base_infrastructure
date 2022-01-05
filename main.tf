module "ROOT_VPC" {
  source          = "../../modules/network/vpc"
  ENV             = var.ENV
  AWS_REGION      = var.AWS_REGION
  SYSTEM          = "TravelOffice"
  VPC_CIDR        = "10.9.6.0/24"
  PUBLIC_SUBNETS  = ["10.9.6.0/28", "10.9.6.32/28",]
  PRIVATE_SUBNETS = [ "10.9.6.64/28", "10.9.6.96/28"]
  DATABASE_SUBNETS = ["10.9.6.128/28", "10.9.6.160/28"]
}
