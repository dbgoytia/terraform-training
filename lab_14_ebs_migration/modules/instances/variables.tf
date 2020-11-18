variable "key_pair_path" {
  description = "Path to the key-pair used for logging into the instance"
  type        = string
}

variable "key_pair_name" {
  description = "Name to attach to the key_pair used for login."
  type        = string
}


variable "instance-type" {
  description = "Instance type to be used for our webserver"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to attach to our instance" 
  type = string
}

variable "vpc_id" {
  description = "VPC id used to install the security group"
  type = string
}