data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_subnets" "vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

//codebuild
data "aws_iam_policy_document" "assume_role_codebuild" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    effect = "Allow"
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = ["arn:aws:codebuild:${local.region}:${local.account_id}:project/${local.environment}-${local.project_name}-codebuild"]
  }

  statement {
    sid    = "AllowECRAccess"
    effect = "Allow"
    actions = [
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage"
    ]
    resources = [aws_ecr_repository.repository.arn]
  }

  statement {
    sid    = "GetAuthToken"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "codecommit:GitPull"
    ]
    resources = ["arn:aws:codecommit:${local.region}:${local.account_id}:${local.environment}-${local.project_name}-codecommit"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = [
      "arn:aws:s3:::${local.environment}-${local.project_name}-codepipeline-bucket*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/${local.project_name}-codebuild",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/${local.project_name}-codebuild:*"
    ]
  }
}

//codepipeline
data "aws_iam_policy_document" "assume_role_codepipeline" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
    effect    = "Allow"
    condition {
      test     = "StringEqualsIfExists"
      variable = "iam:PassedToService"
      values = [
        "cloudformation.amazonaws.com",
        "elasticbeanstalk.amazonaws.com",
        "ec2.amazonaws.com",
        "ecs-tasks.amazonaws.com",
      ]
    }
  }

  statement {
    actions = [
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetRepository",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive",
    ]
    resources = ["arn:aws:codecommit:${local.region}:${local.account_id}:${local.environment}-${local.project_name}-codecommit"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "ecs:*",
      "s3:*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:BatchGetBuildBatches",
      "codebuild:StartBuildBatch",
    ]
    resources = ["arn:aws:codebuild:${local.region}:${local.account_id}:project/${local.environment}-${local.project_name}-codebuild"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "ecr:DescribeImages"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

//codepipeline target
data "aws_iam_policy_document" "assume_role_codepipeline_target" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "codepipeline_target" {
  statement {
    actions = [
      "codepipeline:StartPipelineExecution"
    ]
    resources = ["arn:aws:codepipeline:${local.region}:${local.account_id}:${local.environment}-${local.project_name}-codepipeline"]
    effect    = "Allow"
  }
}
