variable "ENV" {}

variable "BRANCH_NAME" {}

variable "CODEBUILD_ROLE_ARN" {}

variable "CODEPIPELINE_ROLE_ARN" {}

variable "CODESTAR_CONNECTOR_CREDENTIALS" {}

variable "GITHUB_REPO" {}

variable "CODEPIPELINE_BUCKET" {}

variable "FEATURE_NAME" {}
variable "IMAGE" {
  default = "aws/codebuild/standard:6.0"
}
variable "ENV_VARS" {
  default = []
}
variable "TAGS" {}
variable "TF_PLAN_COMPUTE_TYPE" {}

resource "aws_codebuild_project" "tf_cicd_plan" {
  name         = "${var.ENV}-${var.FEATURE_NAME}-cicd-plan"
  description  = "Plan stage for ${var.FEATURE_NAME} project"
  service_role = var.CODEBUILD_ROLE_ARN

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.TF_PLAN_COMPUTE_TYPE
    image                       = var.IMAGE
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    dynamic "environment_variable" {
      for_each = { for key, val in var.ENV_VARS : key => val }
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = lookup(environment_variable.value, "type", "PLAINTEXT")
      }
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "infrastructures/buildspecs/plan-buildspec.yml"
  }

  tags = var.TAGS
}

resource "aws_codebuild_project" "tf_cicd_apply" {
  name         = "${var.ENV}-${var.FEATURE_NAME}-cicd-apply"
  description  = "Apply stage for ${var.FEATURE_NAME} project"
  service_role = var.CODEBUILD_ROLE_ARN

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.IMAGE
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    dynamic "environment_variable" {
      for_each = { for key, val in var.ENV_VARS : key => val }
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = lookup(environment_variable.value, "type", "PLAINTEXT")

      }
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "infrastructures/buildspecs/apply-buildspec.yml"
  }

  tags = var.TAGS
}


resource "aws_codepipeline" "tf_cicd_pipeline" {

  name     = "${var.ENV}-${var.FEATURE_NAME}-cicd-pipeline"
  role_arn = var.CODEPIPELINE_ROLE_ARN

  artifact_store {
    type     = "S3"
    location = var.CODEPIPELINE_BUCKET
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["tf-code"]
      configuration = {
        FullRepositoryId     = var.GITHUB_REPO
        BranchName           = var.BRANCH_NAME
        ConnectionArn        = var.CODESTAR_CONNECTOR_CREDENTIALS
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Plan"
    action {
      name             = "Build"
      category         = "Build"
      provider         = "CodeBuild"
      version          = "1"
      owner            = "AWS"
      input_artifacts  = ["tf-code"]
      output_artifacts = ["tf-code-with-plan"]
      configuration = {
        ProjectName = aws_codebuild_project.tf_cicd_plan.name
      }
    }
  }

  stage {
    name = "Apply"
    action {
      name            = "Apply"
      category        = "Build"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["tf-code-with-plan"]
      configuration = {
        ProjectName = aws_codebuild_project.tf_cicd_apply.name
      }
    }
  }

}