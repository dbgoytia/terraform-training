variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}

variable "region-worker" {
  type    = string
  default = "us-west-2"
}

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "workers-count" {
  type    = number
<<<<<<< HEAD
  default = 2
}

variable "instance-type" {
  type    = string
  default = "t3.micro"
}

=======
  default = 1
}
>>>>>>> 01e8465039e5cd698303c73d52e9c3162a28710f

variable "instance-type" {
  type    = string
  default = "t3.micro"
}


variable "webserver-port" {
  type    = number
  default = 8080
}
