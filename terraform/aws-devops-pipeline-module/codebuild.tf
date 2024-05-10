resource "aws_codebuild_project" "code_build" {
  name          = "${local.environment}-${local.project_name}-codebuild"
  description   = "CodeBuild for the ${local.project_name} project"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild.arn
  tags          = local.tags

  source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.repository.repository_name
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = local.account_id
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = local.region
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.repository.name
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "CONTAINER_NAME"
      value = "${local.environment}-${local.project_name}-container"
      type  = "PLAINTEXT"
    }
  }

  logs_config {
    cloudwatch_logs {
      status      = "ENABLED"
      group_name  = "/aws/codebuild/${local.project_name}-codebuild"
      stream_name = local.project_name
    }
  }

  source_version = "refs/head/master"
}