variable "ENV" {}
variable "BRANCH_NAME" {}
variable "CODESTAR_CONNECTOR_CREDENTIALS" {}


module "IAM" {
  source = "./iam"
  ENV    = var.ENV
}

module "CODEPIPELINE_BUCKET" {
  source = "./s3"
  BUCKET_PREFIX = "backend-codepipeline-artifacts"
}

module "TF_BUCKET" {
  source = "./s3"
  BUCKET_PREFIX = "backend-infrastructure"
}

module "PIPELINE" {
  source                         = "./pipeline"
  ENV                            = var.ENV
  BRANCH_NAME                    = var.BRANCH_NAME
  CODESTAR_CONNECTOR_CREDENTIALS = var.CODESTAR_CONNECTOR_CREDENTIALS
  CODEBUILD_ROLE_ARN             = module.IAM.codebuild_role_arn
  CODEPIPELINE_ROLE_ARN          = module.IAM.codepipeline_role_arn
  CODEPIPELINE_BUCKET            = module.CODEPIPELINE_BUCKET.id
  TF_BUCKET                      = module.TF_BUCKET.id
}