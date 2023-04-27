terraform {
  backend "s3" {
    encrypt = true
    region  = "ap-southeast-1"
    /* key     = "common/environments/${var.ENV}/terraform.tfstate" */
  }
}

provider "aws" {
  region = "ap-southeast-1"
}