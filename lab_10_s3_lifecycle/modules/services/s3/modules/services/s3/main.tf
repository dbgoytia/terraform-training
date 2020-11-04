terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_s3_bucket" "bucket" {

  bucket = var.s3_bucket_name

  acl = "private"

  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"

    tags = {
      "rule"      = "log"
      "autoclean" = "true"
    }

    transition {
      days          = var.days_to_IA
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    transition {
      days          = var.days_to_GLACIER
      storage_class = "GLACIER"
    }

    expiration {
      days = var.days_to_EXPIRE
    }
  }

  tags = {
    Name = "test-s3-lifecycle-bucket"
  }

}
