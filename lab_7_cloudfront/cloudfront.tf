resource "aws_cloudfront_distribution" "cloudfront_distribution" {

  origin {
    domain_name = aws_s3_bucket.site.bucket_regional_domain_name
    origin_path = var.cloudfront_origin_path
    origin_id = "s3-${var.name}"
  }

  enabled = true

  comment = "CDN cloud front test."

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-${var.name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "CDN-tf-test"
  }



}