variable "ENV" {}
variable "BRANCH_NAME" {}
variable "CODESTAR_CONNECTOR_CREDENTIALS" {}
variable "CODEPIPELINE_BUCKET" {}
variable "GITHUB_REPO" {}
variable "FEATURE_NAME" {}
variable "ENV_VARS" {}
variable "TAGS" {}
variable "TF_PLAN_COMPUTE_TYPE" {
  default = "BUILD_GENERAL1_SMALL"
}

module "IAM" {
  source = "./iam"
  ENV    = var.ENV
  TAGS   = var.TAGS
}
module "PIPELINE" {
  source                         = "./pipeline"
  ENV                            = var.ENV
  BRANCH_NAME                    = var.BRANCH_NAME
  CODESTAR_CONNECTOR_CREDENTIALS = var.CODESTAR_CONNECTOR_CREDENTIALS
  CODEBUILD_ROLE_ARN             = module.IAM.codebuild_role_arn
  CODEPIPELINE_ROLE_ARN          = module.IAM.codepipeline_role_arn
  CODEPIPELINE_BUCKET            = var.CODEPIPELINE_BUCKET
  GITHUB_REPO                    = var.GITHUB_REPO
  FEATURE_NAME                   = var.FEATURE_NAME
  ENV_VARS                       = var.ENV_VARS
  TF_PLAN_COMPUTE_TYPE           = var.TF_PLAN_COMPUTE_TYPE
  TAGS                           = var.TAGS
}
