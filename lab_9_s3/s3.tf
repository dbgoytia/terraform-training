resource "aws_s3_bucket" "bucket" {

  bucket = var.s3_bucket_name
  acl    = "private"

  tags = {
    Name = "test-s3-bucket"
  }
}

resource "aws_s3_bucket_policy" "vpce-policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = <<POLICY
{
   "Version": "2012-10-17",
   "Id": "Policy1415115909152",
   "Statement": [
     {
       "Sid": "Access-to-specific-VPCE-only",
       "Principal": "*",
       "Action": "s3:*",
       "Effect": "Deny",
       "Resource": ["arn:aws:s3:::${var.s3_bucket_name}",
                    "arn:aws:s3:::${var.s3_bucket_name}/*"],
       "Condition": {
         "StringNotEquals": {
           "aws:SourceVpce": "${aws_vpc_endpoint.s3.id}"
         }
       }
     }
   ]
}
POLICY
}