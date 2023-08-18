variable "feature_name" {}
variable "vpc_id" {}
variable "public_subnet" {}
variable "domain_arn" {}
variable "hosted_zone" {}
variable "env" {}
variable "tags" {}

module "search_lb" {
  source        = "./loadbalancer"
  vpc_id        = var.vpc_id
  name          = "search-lb"
  public_subnet = var.public_subnet
  domain_arn    = var.domain_arn
  hosted_zone   = var.hosted_zone
  env           = var.env
  feature_name  = var.feature_name
  tags          = var.tags
}

output "lb_endpoint" {
  value = module.search_lb.endpoint
}

output "lb_arn" {
  value = module.search_lb.lb_arn
}
