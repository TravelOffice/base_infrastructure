terraform {
  backend "s3" {
    bucket  = "terraform-state20220108143755951900000001"
    encrypt = true
    key     = "base_infrastructure/environments/dev/terraform.tfstate"
    region  = "ap-southeast-1"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}