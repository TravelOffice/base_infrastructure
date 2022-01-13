variable "ENV" {}
variable "BRANCH_NAME" {}

module "iam" {
  source = "../modules/cicd/iam"
  ENV    = var.ENV
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

resource "aws_codebuild_project" "cicd_apply" {
  name         = "${var.ENV}-base-cicd-apply"
  description  = "Apply stage for terraform"
  service_role = module.iam.codebuild_role_arn

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

  name     = "${var.ENV}-base-cicd-pipeline"
  role_arn = module.iam.codepipeline_role_arn

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
      output_artifacts = ["tf_code"]
      configuration = {
        FullRepositoryId     = "TravelOffice/infrastructure"
        BranchName           = var.BRANCH_NAME
        ConnectionArn        = var.CODESTAR_CONNECTOR_CREDENTIALS
        OutputArtifactFormat = "CODE_ZIP"
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
      input_artifacts = ["tf_code"]
      configuration = {
        ProjectName = aws_codebuild_project.cicd_plan.name
      }
    }
  }

  stage {
    name = "Apply"
    action {
      name             = "Apply"
      category         = "Build"
      provider         = "CodeBuild"
      version          = "1"
      owner            = "AWS"
      input_artifacts  = ["tf_code"]
      output_artifacts = ["tf_apply"]
      configuration = {
        ProjectName = aws_codebuild_project.cicd_apply.name
      }
    }
  }

  stage {
    name = "Upload"
    action {
      name            = "UploadOutputToS3"
      category        = "Deploy"
      provider        = "S3"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["tf_apply"]
      configuration = {
        BucketName = var.CODEPIPELINE_BUCKET,
        Extract    = true
        ObjectKey  = "output-vars/${var.ENV}",
      }
    }
  }

}