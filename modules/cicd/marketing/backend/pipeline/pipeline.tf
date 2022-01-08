variable "ENV" {
  default = "dev"
}

variable "BRANCH_NAME" {
  default = "dev"
}

variable "TF_VERSION" {
  default = "1.1.3"
}

variable "CODEBUILD_ROLE_ARN" {}

variable "CODEPIPELINE_ROLE_ARN" {}

variable "CODESTAR_CONNECTOR_CREDENTIALS" {
  type = string
}

variable "CODEPIPELINE_BUCKET" {}

variable "TF_BUCKET" {}
variable "TF_LOG" {}

resource "aws_codebuild_project" "tf_cicd_download" {
  name         = "${var.ENV}-marketing-cicd-download"
  description  = "Download stage for backend"
  service_role = var.CODEBUILD_ROLE_ARN

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

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
      name  = "TF_BUCKET"
      value = var.TF_BUCKET
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
    buildspec = "buildspecs/download-buildspec.yml"
  }
}

resource "aws_codebuild_project" "tf_cicd_plan" {
  name         = "${var.ENV}-marketing-cicd-plan"
  description  = "Plan stage for marketing project"
  service_role = var.CODEBUILD_ROLE_ARN

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TF_BUCKET"
      value = var.TF_BUCKET
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
}

resource "aws_codebuild_project" "tf_cicd_apply" {
  name         = "${var.ENV}-marketing-cicd-apply"
  description  = "Apply stage for marketing project"
  service_role = var.CODEBUILD_ROLE_ARN

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TF_BUCKET"
      value = var.TF_BUCKET
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
}


resource "aws_codepipeline" "tf_cicd_pipeline" {

  name     = "${var.ENV}-marketing-cicd-pipeline"
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
        FullRepositoryId     = "TravelOffice/marketing_backend"
        BranchName           = var.BRANCH_NAME
        ConnectionArn        = var.CODESTAR_CONNECTOR_CREDENTIALS
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Download"
    action {
      name            = "Download"
      category        = "Build"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["tf-code"]
      output_artifacts = ["tf-code-with-var"]
      configuration = {
        ProjectName = aws_codebuild_project.tf_cicd_download.name
      }
    }
  }

  stage {
    name = "Plan"
    action {
      name            = "Build"
      category        = "Build"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["tf-code-with-var"]
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
      input_artifacts = ["tf-code-with-var"]
      configuration = {
        ProjectName = aws_codebuild_project.tf_cicd_apply.name
      }
    }
  }

}