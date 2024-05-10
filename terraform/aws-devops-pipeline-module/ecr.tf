resource "aws_ecr_repository" "repository" {
  name                 = "${local.environment}-${local.project_name}-ecr"
  image_tag_mutability = "MUTABLE"
  tags                 = local.tags

  image_scanning_configuration {
    scan_on_push = true
  }
}
