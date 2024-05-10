locals {
  project_name = var.project_name
  environment  = var.environment
  account_id   = data.aws_caller_identity.current.account_id
  region       = data.aws_region.current.name
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}