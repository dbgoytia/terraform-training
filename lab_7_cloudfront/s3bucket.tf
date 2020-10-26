resource "aws_s3_bucket" "site" {
  bucket = var.s3_bucket_name
  acl    = "public-read"
  policy = data.aws_iam_policy_document.website_policy.json
  website {
    index_document = "index.html"
    error_document = "404.html"
  }
  tags = {
    Name = "test-cloudfront-tf"
  }
}