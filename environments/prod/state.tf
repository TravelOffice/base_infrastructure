terraform {
  backend "s3" {
    bucket  = "prod-itab-terraform-state"
    encrypt = true
    key     = "base_infrastructure/environments/prod/terraform.tfstate"
    region  = "ap-southeast-1"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}