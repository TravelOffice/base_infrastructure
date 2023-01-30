variable "ENV" {
  default = "dev"
}

variable "TF_VERSION" {
  default = "1.1.4"
}

variable "TF_LOG" {
  default = "ERROR"
}

variable "BRANCH_NAME" {
  default = "dev"
}

variable "AWS_REGION" {
  default = "ap-southeast-1"
}

variable "BASE_BACKEND_VPC_CIDR" {
  default = "10.9.255.0/24"
}

variable "BASE_BACKEND_PRIVATE_SUBNETS_CIDR" {
  default = ["10.9.255.0/28", "10.9.255.32/28"]
}
variable "BASE_BACKEND_PUBLIC_SUBNETS_CIDR" {
  default = ["10.9.255.64/28", "10.9.255.96/28"]
}

variable "MARKETING_VPC_CIDR" {
  default = "10.9.0.0/24"
}

variable "MARKETING_PUBLIC_SUBNETS_CIDR" {
  default = ["10.9.0.64/28", "10.9.0.96/28"]
}

variable "MARKETING_PRIVATE_SUBNETS_CIDR" {
  default = ["10.9.0.0/28", "10.9.0.32/28"]
}

variable "MARKETING_DATABASE_SUBNETS_CIDR" {
  default = ["10.9.0.128/28", "10.9.0.160/28"]
}
