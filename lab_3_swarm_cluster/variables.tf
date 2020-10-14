variable "profile" {
    type = string 
    default = "default"
}

variable "region-east" {
    type = string
    default = "us-east-1"
}


variable "instance-type" {
    type = string
    default  = "t2.micro"
}

variable "workers-count" {
    type = number
    default = 1
}