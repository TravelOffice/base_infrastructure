output "MARKETING_VPC_ID" {
  value = module.marketing_vpc.id
}

output "MARKETING_PUBLIC_SUBNETS" {
  value = module.marketing_vpc.public_subnets
}

output "MARKETING_PRIVATE_SUBNETS" {
  value = module.marketing_vpc.private_subnets
}

output "MARKETING_DATABASE_SUBNETS" {
  value = module.marketing_vpc.database_subnets
}

output "AWS_REGION" {
  value = "ap-southeast-1"
}

output "CODESTAR_CONNECTOR_CREDENTIALS" {
  value = "arn:aws:codestar-connections:ap-southeast-1:249593777629:connection/f7623ad7-387d-4abc-ae08-7b83cd464851"
}

output "STANDARD_LAMBDA_IAM_ROLE" {
  value = module.standard_lambda_iam_role.arn
}

output "COGNITO_USER_POOL_ID" {
  value = module.cognito_user_pool.id
}