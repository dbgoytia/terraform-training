data "aws_iam_policy_document" "website_policy" {
  provider = aws.region-east

  statement {

    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${var.domain_name}/*"
    ]
  }
}