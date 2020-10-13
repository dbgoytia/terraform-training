variable "region-east" {
  type    = string
  default = "us-east-1"
}

variable "region-west" {
  type    = string
  default = "us-west-2"
} 

variable "profile" {
    type = string
    default = "default"
}

variable "instance-type" {
    type = string
    default = "t3.micro"
}

variable "workers-count" {
    type = number
    default = 1
}