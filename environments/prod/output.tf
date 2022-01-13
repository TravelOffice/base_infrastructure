output "vpc_id" {
  value = module.ROOT_VPC.id
}

output "public_subnets" {
  value = module.ROOT_VPC.public_subnets
}

output "private_subnets" {
  value = module.ROOT_VPC.private_subnets
}

output "database_subnets" {
  value = module.ROOT_VPC.database_subnets
}