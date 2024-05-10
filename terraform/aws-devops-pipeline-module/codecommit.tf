resource "aws_codecommit_repository" "repository" {
  repository_name = "${local.environment}-${local.project_name}-codecommit"
  description     = "This is the code commit repository for the ${local.project_name} project"
  tags            = local.tags
}