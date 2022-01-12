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

output "AWS_REGION" {
  value = "ap-southeast-1"
}

output "CODESTAR_CONNECTOR_CREDENTIALS" {
  value = "arn:aws:codestar-connections:ap-southeast-1:249593777629:connection/f7623ad7-387d-4abc-ae08-7b83cd464851"
}