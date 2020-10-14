#############################
###  NETWORK PROVISIONING ###
#############################

# VPC in us-east-1
resource "aws_vpc" "vpc_east" {
    provider = aws.region-east
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "vpc_east"
    }
}

##################################
# Subnetting:                    #   
# Create two subnets:            #
# * 10.0.1.0/24 for managernodes #
# * 10.0.2.0/24 for worker nodes #
# * Spread them across to azs    # 
##################################

# Retrieve availability zones
data "aws_availability_zones" "azs" {
    provider = aws.region-east
    state = "available"
}

# Public subnet for manager nodes
resource "aws_subnet" "public_manager" {
    provider = aws.region-east
    availability_zone = element(data.aws_availability_zones.azs.names, 0)
    vpc_id = aws_vpc.vpc_east.id
    cidr_block = "10.0.1.0/24"
}

# Public subnet for worker nodes
resource "aws_subnet" "public_workers" {
    provider = aws.region-east
    availability_zone = element(data.aws_availability_zones.azs.names, 1)
    vpc_id = aws_vpc.vpc_east.id
    cidr_block = "10.0.2.0/24"
}

#####################
# Internet Gateways #
#####################

# Internet gateway for VPC
resource "aws_internet_gateway" "gw" {
    provider = aws.region-east
    vpc_id = aws_vpc.vpc_east.id
    tags = {
        Name = "gw"
    }
}


################
# Route Tables #
################

# Allow traffic from our internet gateway into the VPC:
resource "aws_route_table" "rt_east" {
    provider = aws.region-east
    vpc_id = aws_vpc.vpc_east.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    lifecycle {
        ignore_changes = all
    }

    tags = {
        Name = "East-Region-RT"
    }
}


# Associate configuration
resource "aws_main_route_table_association" "set-east-region-assoc" {
    provider = aws.region-east
    vpc_id = aws_vpc.vpc_east.id
    route_table_id = aws_route_table.rt_east.id
}




















