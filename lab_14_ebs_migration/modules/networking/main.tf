# VPC specified
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Lab = "EBS migration lab"
  }
}

# Create an internet gateway associated with our VPC
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
}

# Create one subnet for the VPC
resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_block_subnet
}

# Route table
resource "aws_route_table" "internet_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    # Allow traffic from our internet gateway
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Lab = "EBS migration lab"
  }
}
