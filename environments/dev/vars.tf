variable "ENV" {
  default = "dev"
}

variable "TF_VERSION" {
  default = "1.1.3"
}

variable "TF_LOG" {
  default = "TRACE"
}

variable "BRANCH_NAME" {
  default = "dev"
}

variable "AWS_REGION" {
  default = "ap-southeast-1"
}

variable "VPC_CIDR" {
  default = "10.9.0.0/24"
}

variable "PUBLIC_SUBNETS_CIDR" {
  default = ["10.9.0.192/28", "10.9.0.224/28"]
}

variable "PRIVATE_SUBNETS_CIDR" {
  default = ["10.9.0.0/28", "10.9.0.32/28", "10.9.0.64/28", "10.9.0.96/28"]
}

variable "DATABASE_SUBNETS_CIDR" {
  default = ["10.9.0.128/28", "10.9.0.160/28"]
}

variable "CODESTAR_CONNECTOR_CREDENTIALS" {
  default = "arn:aws:codestar-connections:ap-southeast-1:249593777629:connection/f7623ad7-387d-4abc-ae08-7b83cd464851"
}

variable "TF_BUCKET" {
  default = "terraform-state20220108143755951900000001"
}

variable "CODEPIPELINE_BUCKET" {
  default = "codepipeline-artifacts20220108172710412300000001"
}

variable "RDS_USERNAME" {
  default = "admin_account"
}