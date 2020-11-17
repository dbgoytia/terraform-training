variable "s3_bucket_name" {
  type    = string
}

variable "days_to_IA" {
    type = number
}

variable "days_to_GLACIER" {
    type = number
}

variable "days_to_EXPIRE" {
    type = number
}