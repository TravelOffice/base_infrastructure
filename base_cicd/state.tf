terraform {
  backend "s3" {
    bucket  = "suni-terraform-state"
    encrypt = true
    region  = "ap-southeast-1"
    /* key     = "common/environments/${var.ENV}/terraform.tfstate" */
  }
}

provider "aws" {
  region = "ap-southeast-1"
}