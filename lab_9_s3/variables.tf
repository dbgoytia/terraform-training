variable "vpc-cidr-block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet-range" {
  type    = string
  default = "10.0.1.0/24"
}

variable "instance-type" {
  type    = string
  default = "t3.micro"
}

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "s3_bucket_name" {
  type    = string
  default = "test-s3-bucket-ssa"
}