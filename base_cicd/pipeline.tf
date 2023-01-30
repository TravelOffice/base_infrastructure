data "http" "infra" {
  url = "https://raw.githubusercontent.com/TravelOffice/infrastructure-constant/master/infrastructure.json"
}

variable "ENV" {}
variable "BRANCH_NAME" {}
variable "IMAGE" {
  default = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
}
locals {
  constants                      = jsondecode(data.http.infra.body)
  codestar_connector_credentials = local.constants["CODESTAR_CONNECTOR_CREDENTIALS"]
  tf_state_bucket                = local.constants["TF_STATE_BUCKET"]
  codepipeline_bucket            = local.constants["CODEPIPELINE_BUCKET"]

  tags = {
    Terraform = true
    ENV       = var.ENV
  }

  is_prod = var.ENV == "prod"

  stages = [
    {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["tf_code"]
      configuration = {
        FullRepositoryId     = "TravelOffice/base_infrastructure"
        BranchName           = var.BRANCH_NAME
        ConnectionArn        = local.codestar_connector_credentials
        OutputArtifactFormat = "CODE_ZIP"
      }
    },
    {
      name            = "Plan"
      category        = "Build"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["tf_code"]
      configuration = {
        ProjectName = aws_codebuild_project.cicd_plan.name
      }
    },
    {
      name     = "Approve"
      category = "Approval"
      provider = "Manual"
      version  = "1"
      owner    = "AWS"
    },
    {
      name            = "Apply"
      category        = "Build"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["tf_code"]
      configuration = {
        ProjectName = aws_codebuild_project.cicd_apply.name
      }
    },
    {
      name            = "TriggerSubPipeline"
      category        = "Build"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["tf_code"]
      configuration = {
        ProjectName = aws_codebuild_project.cicd_trigger_sub_pipeline.name
      }
    }
  ]
}

module "iam" {
  source = "../modules/cicd/iam"
  ENV    = var.ENV
  TAGS   = local.tags
}

resource "aws_codebuild_project" "cicd_plan" {
  name         = "${var.ENV}-base-cicd-plan"
  description  = "Plan stage for base codepipeline"
  service_role = module.iam.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.IMAGE
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TF_BUCKET"
      value = local.tf_state_bucket
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "BUILD_ENV"
      value = var.ENV
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "TF_VERSION"
      value = var.TF_VERSION
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "TF_LOG"
      value = var.TF_LOG
      type  = "PLAINTEXT"
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspecs/plan-buildspec.yml"
  }

  tags = local.tags
}

resource "aws_codebuild_project" "cicd_apply" {
  name         = "${var.ENV}-base-cicd-apply"
  description  = "Apply stage for terraform"
  service_role = module.iam.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.IMAGE
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TF_BUCKET"
      value = local.tf_state_bucket
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "BUILD_ENV"
      value = var.ENV
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "TF_VERSION"
      value = var.TF_VERSION
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "TF_LOG"
      value = var.TF_LOG
      type  = "PLAINTEXT"
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspecs/apply-buildspec.yml"
  }

  tags = local.tags
}

resource "aws_codebuild_project" "cicd_trigger_sub_pipeline" {
  name         = "${var.ENV}-base-cicd-trigger-sub-pipeline"
  description  = "Apply stage for terraform"
  service_role = module.iam.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.IMAGE
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TRIGGER_PIPELINES"
      value = "${var.ENV}-base-backend-cicd-pipeline ${var.ENV}-marketing-backend-cicd-pipeline ${var.ENV}-mail-backend-cicd-pipeline"
      type  = "PLAINTEXT"
    }

  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspecs/trigger-sub-pipeline-buildspec.yml"
  }

  tags = local.tags
}


resource "aws_codepipeline" "tf_cicd_pipeline" {

  name     = "${var.ENV}-base-cicd-pipeline"
  role_arn = module.iam.codepipeline_role_arn

  artifact_store {
    type     = "S3"
    location = local.codepipeline_bucket
  }

  dynamic "stage" {
    # In dev environment, Approve stage will be ignore
    for_each = { for key, val in local.stages :
    key => val if local.is_prod || val.name != "Approve" }
    content {
      name = stage.value.name
      action {
        name             = stage.value.name
        category         = stage.value.category
        owner            = stage.value.owner
        provider         = stage.value.provider
        version          = stage.value.version
        input_artifacts  = lookup(stage.value, "input_artifacts", null)
        output_artifacts = lookup(stage.value, "output_artifacts", null)
        configuration    = lookup(stage.value, "configuration", null)
      }
    }

  }

  tags = local.tags
}
