
variable "region-east" {
  type    = string
  default = "us-east-1"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "s3_bucket_name" {
  type    = string
  default = "test-cloudfront-devops-2020"
}

variable "cloudfront_origin_path" {
  description = "Root path in the bucket for cloudfront"
  default     = ""
}

variable "name" {
  description = "Name of the application"
  default     = "cdn-test-2020"
}