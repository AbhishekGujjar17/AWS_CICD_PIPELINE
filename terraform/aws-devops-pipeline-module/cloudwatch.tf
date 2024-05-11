resource "aws_cloudwatch_event_rule" "codecommit_event_rule" {
  name        = "${local.environment}-${local.project_name}-codecommmit-event-rule"
  description = "Rule to trigger CodePipeline on CodeCommit events"
  event_pattern = jsonencode({
    source        = ["aws.codecommit"],
    "detail-type" = ["CodeCommit Repository State Change"],
    resources     = ["arn:aws:codecommit:${local.region}:${local.account_id}:${local.environment}-${local.project_name}-codecommit"],
    detail = {
      event         = ["referenceCreated", "referenceUpdated"],
      referenceType = ["branch"],
      referenceName = [var.branch_name]
    }
  })
}

resource "aws_cloudwatch_event_target" "codepipeline_target" {
  rule     = aws_cloudwatch_event_rule.codecommit_event_rule.name
  arn      = "arn:aws:codepipeline:${local.region}:${local.account_id}:${local.environment}-${local.project_name}-codepipeline"
  role_arn = aws_iam_role.codepipeline_target_rule.arn
}