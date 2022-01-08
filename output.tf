output "marketing_vpc_id" {
  value = module.marketing_vpc.id
}

output "marketing_public_subnets" {
    value = module.marketing_vpc.public_subnets
}

output "marketing_private_subnets" {
    value = module.marketing_vpc.private_subnets
}

output "marketing_database_subnets" {
    value = module.marketing_vpc.database_subnets
}