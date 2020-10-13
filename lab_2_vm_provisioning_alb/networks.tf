# Provision a VPC for us-east-1
resource "aws_vpc" "vpc_east" {
  provider             = aws.region-east
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-east"
  }
}

# Provision a VPC for us-west-2
resource "aws_vpc" "vpc_west" {
    provider = aws.region-west
    cidr_block = "192.168.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "vpc-west"
    }
}

# Use datasource to get the availability zones
data "aws_availability_zones" "azs" {
    provider = aws.region-east
    state = "available"
}

# Create public subnet-1 for vpc east
resource "aws_subnet" "subnet_1_east" {
    provider = aws.region-east
    availability_zone = element(data.aws_availability_zones.azs.names, 0)
    vpc_id = aws_vpc.vpc_east.id
    cidr_block =  "10.0.1.0/24"
}

# Create a public subnet-2 for vpc east
resource "aws_subnet" "subnet_2_east" {
    provider = aws.region-east
    availability_zone = element(data.aws_availability_zones.azs.names, 1)
    vpc_id = aws_vpc.vpc_east.id
    cidr_block = "10.0.2.0/24"
}

# Create a public subnet-2 for vpc west 
resource "aws_subnet" "subnet_1_west" {
    provider = aws.region-west
    vpc_id = aws_vpc.vpc_west.id
    cidr_block = "192.168.1.0/24"
}

# Create peering request for both VPC's
resource "aws_vpc_peering_connection" "useast1-uswest2" {
    provider = aws.region-east
    peer_vpc_id = aws_vpc.vpc_west.id
    vpc_id = aws_vpc.vpc_east.id
    peer_region = var.region-west
}

# Acceept the VPC pairing request
resource "aws_vpc_peering_connection_accepter" "accept_peering" {
    provider = aws.region-west
    vpc_peering_connection_id = aws_vpc_peering_connection.useast1-uswest2.id
    auto_accept = true
}

# Create Internet Gateway in us-east-1
resource "aws_internet_gateway" "gw_east" {
    provider = aws.region-east
    vpc_id = aws_vpc.vpc_east.id
    tags = {
        Name = "gw-east"
    }
}

# Create Internet Gateway for us-west-2
resource "aws_internet_gateway" "gw_west" {
    provider = aws.region-west
    vpc_id = aws_vpc.vpc_west.id
    tags = {
        Name = "gw-west"
    }
}

# Create route table for us-east-1
# allow traffic from vpc in us-west-2
resource "aws_route_table" "rt_east" {
    provider = aws.region-east
    vpc_id = aws_vpc.vpc_east.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw_east.id 
    }

    route {
        cidr_block = "192.168.1.0/24"
        vpc_peering_connection_id = aws_vpc_peering_connection.useast1-uswest2.id
    }

    lifecycle {
        ignore_changes = all
    }

    tags = {
        Name = "East-Region-RT"
    }
}


# Overwrite default VPC route table configuration us-east-1
resource "aws_main_route_table_association" "set-east-region-rt-assoc" {
    provider = aws.region-east
    vpc_id = aws_vpc.vpc_east.id 
    route_table_id = aws_route_table.rt_east.id
}


# Create route table for us-west-2
resource "aws_route_table" "rt_west" {
    provider = aws.region-west
    vpc_id = aws_vpc.vpc_west.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw_west.id
    }

    route {
        cidr_block  = "10.0.1.0/24"
        vpc_peering_connection_id = aws_vpc_peering_connection.useast1-uswest2.id
    }

    route {
        cidr_block = "10.0.2.0/24"
        vpc_peering_connection_id = aws_vpc_peering_connection.useast1-uswest2.id
    }

    lifecycle {
        ignore_changes = all
    }

    tags = {
        Name = "West-Region-RT"
    }
}

# Overwrite default VPC route table configuration us-west-2
resource "aws_main_route_table_association" "set-west-region-rt-assoc" {
    provider = aws.region-west
    vpc_id = aws_vpc.vpc_west.id 
    route_table_id = aws_route_table.rt_west.id
}

