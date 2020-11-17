terraform {
  required_version = ">= 0.12, < 0.13"
}

# Create an S3 bucket, with a static website bucket-policy, and public ACL.
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket-name

  acl = var.acl-kind

  policy = data.aws_iam_policy_document.website_policy.json

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name = var.bucket-name
    Environment = var.environment
  }
}