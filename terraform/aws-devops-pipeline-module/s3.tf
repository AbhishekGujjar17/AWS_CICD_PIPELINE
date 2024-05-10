resource "aws_s3_bucket" "codepipeline" {
  bucket = "${local.environment}-${local.project_name}-codepipeline-bucket"
  tags   = local.tags
}

resource "aws_s3_bucket_public_access_block" "codepipeline" {
  bucket                  = aws_s3_bucket.codepipeline.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}