variable "ENV" {}
variable "BRANCH_NAME" {}
variable "CODESTAR_CONNECTOR_CREDENTIALS" {}
variable "TF_BUCKET" {}
variable "TF_LOG" {}
variable "CODEPIPELINE_BUCKET" {}
variable "GITHUB_REPO" {}

module "IAM" {
  source = "../../iam"
  ENV    = var.ENV
}


module "PIPELINE" {
  source                         = "./pipeline"
  ENV                            = var.ENV
  BRANCH_NAME                    = var.BRANCH_NAME
  CODESTAR_CONNECTOR_CREDENTIALS = var.CODESTAR_CONNECTOR_CREDENTIALS
  CODEBUILD_ROLE_ARN             = module.IAM.codebuild_role_arn
  CODEPIPELINE_ROLE_ARN          = module.IAM.codepipeline_role_arn
  CODEPIPELINE_BUCKET            = var.CODEPIPELINE_BUCKET
  TF_BUCKET                      = var.TF_BUCKET
  TF_LOG                         = var.TF_LOG
  GITHUB_REPO                    = var.GITHUB_REPO
}