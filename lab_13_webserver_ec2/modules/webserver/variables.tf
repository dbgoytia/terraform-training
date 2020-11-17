variable "instance-type" {
  description = "Instance type to deploy"
  type        = string
}

variable "profile" {
  description = "aws profile to use"
  type = string
  default = "default"
}