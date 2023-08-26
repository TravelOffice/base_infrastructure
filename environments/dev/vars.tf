variable "ENV" {
  default = "dev"
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

variable "DYNAMO_BILLING_MODE" {
  default = "PROVISIONED"
}

variable "DYNAMO_AUTOSCALING_ENABLED" {
  default = false
}

variable "PITR" {
  default = false
}


// chat_table
variable "CHAT_WCU" {
  default = 1
}

variable "CHAT_MAX_WCU" {
  default = 1
}

variable "CHAT_RCU" {
  default = 1
}

variable "CHAT_MAX_RCU" {
  default = 1
}

// mail_table
variable "MAIL_WCU" {
  default = 1
}

variable "MAIL_MAX_WCU" {
  default = 1
}

variable "MAIL_RCU" {
  default = 1
}

variable "MAIL_MAX_RCU" {
  default = 1
}

// marketplace_role_permmisison_table
variable "MK_ROLE_WCU" {
  default = 1
}

variable "MK_ROLE_MAX_WCU" {
  default = 1
}

variable "MK_ROLE_RCU" {
  default = 1
}

variable "MK_ROLE_MAX_RCU" {
  default = 1
}

// marketplace_table
variable "MK_WCU" {
  default = 1
}

variable "MK_MAX_WCU" {
  default = 1
}


variable "MK_RCU" {
  default = 1
}

variable "MK_MAX_RCU" {
  default = 1
}

// role_permission_table
variable "ROLE_WCU" {
  default = 1
}

variable "ROLE_MAX_WCU" {
  default = 1
}

variable "ROLE_RCU" {
  default = 1
}

variable "ROLE_MAX_RCU" {
  default = 1
}

// statistic_table
variable "STATISTIC_WCU" {
  default = 1
}

variable "STATISTIC_MAX_WCU" {
  default = 1
}

variable "STATISTIC_RCU" {
  default = 1
}

variable "STATISTIC_MAX_RCU" {
  default = 1
}

// travel_table
variable "TRAVEL_WCU" {
  default = 1
}

variable "TRAVEL_MAX_WCU" {
  default = 1
}

variable "TRAVEL_RCU" {
  default = 1
}

variable "TRAVEL_MAX_RCU" {
  default = 1
}

variable "DELETION_PROTECTION_ENABLED" {
  default = false
}
