resource "aws_s3_bucket" "website_bucket" {
  provider = aws.region-east
  bucket   = var.domain_name
  acl      = "public-read"
  policy   = data.aws_iam_policy_document.website_policy.json
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = {
    Name = "test-s3-static-site"
  }
}
