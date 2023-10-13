variable "ENV" {
  default = "prod"
}

variable "SCM_CONSTANT_ARN" {
  default = "arn:aws:secretsmanager:ap-southeast-1:800823848420:secret:prod-infrastructure-constant-FEt8TM"
}

variable "TF_LOG" {
  default = "ERROR"
}

variable "BRANCH_NAME" {
  default = "master"
}

variable "AWS_REGION" {
  default = "ap-southeast-1"
}

variable "BASE_BACKEND_VPC_CIDR" {
  default = "10.10.255.0/24"
}

variable "BASE_BACKEND_PRIVATE_SUBNETS_CIDR" {
  default = ["10.10.255.0/28", "10.10.255.32/28"]
}
variable "BASE_BACKEND_PUBLIC_SUBNETS_CIDR" {
  default = ["10.10.255.64/28", "10.10.255.96/28"]
}

variable "MARKETING_VPC_CIDR" {
  default = "10.10.0.0/24"
}

variable "MARKETING_PUBLIC_SUBNETS_CIDR" {
  default = ["10.10.0.64/28", "10.10.0.96/28"]
}

variable "MARKETING_PRIVATE_SUBNETS_CIDR" {
  default = ["10.10.0.0/28", "10.10.0.32/28"]
}

variable "MARKETING_DATABASE_SUBNETS_CIDR" {
  default = ["10.10.0.128/28", "10.10.0.160/28"]
}


variable "DYNAMO_BILLING_MODE" {
  default = "PROVISIONED"
}

variable "DYNAMO_AUTOSCALING_ENABLED" {
  default = true
}

variable "PITR" {
  default = true
}


// chat_table
variable "CHAT_WCU" {
  default = 50
}

variable "CHAT_MAX_WCU" {
  default = 100
}

variable "CHAT_RCU" {
  default = 50
}

variable "CHAT_MAX_RCU" {
  default = 100
}

// mail_table
variable "MAIL_WCU" {
  default = 50
}

variable "MAIL_MAX_WCU" {
  default = 100
}

variable "MAIL_RCU" {
  default = 50
}

variable "MAIL_MAX_RCU" {
  default = 100
}

// marketplace_role_permission_table
variable "MK_ROLE_WCU" {
  default = 50
}

variable "MK_ROLE_MAX_WCU" {
  default = 100
}

variable "MK_ROLE_RCU" {
  default = 50
}

variable "MK_ROLE_MAX_RCU" {
  default = 100
}

// marketplace_table
variable "MK_WCU" {
  default = 50
}

variable "MK_MAX_WCU" {
  default = 100
}


variable "MK_RCU" {
  default = 50
}

variable "MK_MAX_RCU" {
  default = 100
}

// role_permission_table
variable "ROLE_WCU" {
  default = 50
}

variable "ROLE_MAX_WCU" {
  default = 100
}

variable "ROLE_RCU" {
  default = 50
}

variable "ROLE_MAX_RCU" {
  default = 100
}

// statistic_table
variable "STATISTIC_WCU" {
  default = 50
}

variable "STATISTIC_MAX_WCU" {
  default = 100
}

variable "STATISTIC_RCU" {
  default = 50
}

variable "STATISTIC_MAX_RCU" {
  default = 100
}

// notification_table
variable "NOTIFICATION_WCU" {
  default = 50
}

variable "NOTIFICATION_MAX_WCU" {
  default = 100
}

variable "NOTIFICATION_RCU" {
  default = 50
}

variable "NOTIFICATION_MAX_RCU" {
  default = 100
}

// setting_table
variable "SETTING_WCU" {
  default = 10
}

variable "SETTING_MAX_WCU" {
  default = 50
}

variable "SETTING_RCU" {
  default = 10
}

variable "SETTING_MAX_RCU" {
  default = 50
}

// travel_table
variable "TRAVEL_WCU" {
  default = 50
}

variable "TRAVEL_MAX_WCU" {
  default = 100
}

variable "TRAVEL_RCU" {
  default = 50
}

variable "TRAVEL_MAX_RCU" {
  default = 100
}

variable "DELETION_PROTECTION_ENABLED" {
  default = true
}
