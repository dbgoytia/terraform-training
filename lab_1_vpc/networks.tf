# VPC for us-east-1
resource "aws_vpc" "vpc_east" {
  provider             = aws.region-east
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-east"
  }
}

resource "aws_vpc" "vpc_west" {
  provider             = aws.region-west
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-west"
  }
}


data "aws_availability_zones" "azs" {
  provider = aws.region-east
  state    = "available"
}


# Create a subnet # 1 in us-east-1
resource "aws_subnet" "subnet_1_east" {
  provider          = aws.region-east
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_east.id
  cidr_block        = "10.0.1.0/24"
}

# Create a subnet # 2 in us-east-1
resource "aws_subnet" "subnet_2_east" {
  provider          = aws.region-east
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc_east.id
  cidr_block        = "10.0.2.0/24"
}


# Create a subnet #1 for us-west-2
resource "aws_subnet" "subnet_1_west" {
  provider   = aws.region-west
  vpc_id     = aws_vpc.vpc_west.id
  cidr_block = "192.168.1.0/24"
}


# Create peering request
# Initiate Peering connection request from us-east-1
resource "aws_vpc_peering_connection" "useast1-uswest2" {
  provider    = aws.region-east
  peer_vpc_id = aws_vpc.vpc_west.id
  vpc_id      = aws_vpc.vpc_east.id
  peer_region = var.region-west
}


# Accept VPC peering request in us-west-2 from us-east-1
resource "aws_vpc_peering_connection_accepter" "accept_peering" {
  provider                  = aws.region-west
  vpc_peering_connection_id = aws_vpc_peering_connection.useast1-uswest2.id
  auto_accept               = true
}



# Create IGW in us-east-1
resource "aws_internet_gateway" "igw_east" {
  provider = aws.region-east
  vpc_id   = aws_vpc.vpc_east.id
}


# Create IGW in us-west-2
resource "aws_internet_gateway" "igw_west" {
  provider = aws.region-west
  vpc_id   = aws_vpc.vpc_west.id
}

# Create route table in us-east-1
resource "aws_route_table" "internet_route_east" {
  provider = aws.region-east
  vpc_id   = aws_vpc.vpc_east.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_east.id
  }
  route {
    cidr_block                = "192.168.1.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.useast1-uswest2.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "east-region-RT"
  }
}

# Create a route table in us-west-2
resource "aws_route_table" "internet_route_west" {
  provider = aws.region-west
  vpc_id   = aws_vpc.vpc_west.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_west.id
  }
  route {
    cidr_block                = "10.0.1.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.useast1-uswest2.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "west-region-RT"
  }
}


# Overwrite default route table of VPC(East) with our route table entires
resource "aws_main_route_table_association" "set-east-default-rt-assoc" {
  provider       = aws.region-east
  vpc_id         = aws_vpc.vpc_east.id
  route_table_id = aws_route_table.internet_route_east.id
}


# Overwrite default route table of VPC(West) with our route table entires
resource "aws_main_route_table_association" "set-west-default-rt-assoc" {
  provider       = aws.region-west
  vpc_id         = aws_vpc.vpc_west.id
  route_table_id = aws_route_table.internet_route_west.id
}

