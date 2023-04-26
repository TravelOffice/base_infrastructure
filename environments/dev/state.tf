terraform {
  backend "s3" {
    bucket  = "dev-itab-terraform-state"
    encrypt = true
    key     = "base_infrastructure/environments/dev/terraform.tfstate"
    region  = "ap-southeast-1"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}