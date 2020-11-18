variable "subnet_availability_zone" {
  description = "Availability zone where our instance was created."
  type        = string
}

variable "instance-id" {
  description = "Instance in which to attach the provisioned EBS volume"
  type        = string
}

