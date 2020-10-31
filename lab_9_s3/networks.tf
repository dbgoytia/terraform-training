# Create a vpc over in region east
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr-block
  tags = {
    Name = "s3-test-vpc"
  }
}

# This will enable communication with the internet
# Also provides communication with other AWS Services
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "s3-test-igw"
  }
}

# Provision a subnet in the VPC
# Subnet must be 10.0.1.0/24
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet-range
  tags = {
    Name = "s3-test-subnet"
  }
}

# Route table for VPC
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  lifecycle {
    ignore_changes = all
  }

  tags = {
    Name = "s3-test-route-table"
  }
}

# Create a VPC endpoint for accessing s3 service
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
}

# Create the endpoint association with the route table
resource "aws_vpc_endpoint_route_table_association" "rt-vpce" {
  route_table_id  = aws_route_table.rt.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

# Create route table association
resource "aws_route_table_association" "rt-assoc" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}



