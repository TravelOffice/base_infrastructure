terraform {
  backend "s3" {
    bucket  = "terraform-state20220108143755951900000001"
    encrypt = true
    region  = "ap-southeast-1"
    /* key     = "common/environments/${var.ENV}/terraform.tfstate" */
  }
}

provider "aws" {
  region = "ap-southeast-1"
}