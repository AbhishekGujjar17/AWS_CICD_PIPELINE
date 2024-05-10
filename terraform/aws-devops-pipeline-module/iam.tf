resource "aws_iam_role" "codebuild" {
  name               = "${local.environment}-${local.project_name}-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_codebuild.json
  tags               = local.tags
}

resource "aws_iam_policy" "codebuild" {
  name        = "${local.environment}-${local.project_name}-codebuild-policy"
  description = "Policy used by codebuild for ${local.project_name} project"
  policy      = data.aws_iam_policy_document.codebuild.json
  tags        = local.tags
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.codebuild.arn
}

resource "aws_iam_role" "codepipeline" {
  name               = "${local.environment}-${local.project_name}-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_codepipeline.json
  tags               = local.tags
}

resource "aws_iam_policy" "codepipeline" {
  name        = "${local.environment}-${local.project_name}-codepipeline-policy"
  description = "Policy used by codepipeline for ${local.project_name} project"
  policy      = data.aws_iam_policy_document.codepipeline.json
  tags        = local.tags
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = aws_iam_policy.codepipeline.arn
}
