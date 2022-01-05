variable "ENV" {
  default = "prod"
}

variable "PREFIX" {
  default = "root"
}

variable "AWS_REGION" {
  default = "ap-southeast-1"
}

variable "VPC_CIDR" {
  default = "10.10.0.0/24"
}

variable "PUBLIC_SUBNETS_CIDR" {
  default = ["10.10.0.0/28", "10.10.0.32/28"]
}

variable "PRIVATE_SUBNETS_CIDR" {
  default = ["10.10.0.64/28", "10.10.0.96/28"]
}

variable "DATABASE_SUBNETS_CIDR" {
  default = ["10.10.0.128/28", "10.10.0.160/28"]
}