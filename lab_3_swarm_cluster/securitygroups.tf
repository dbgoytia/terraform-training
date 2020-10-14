#########################
###  Security Groups  ###
#########################

# Allow all traffic for the vpc-east
resource "aws_security_group" "swarm-sg-east" {
    provider = aws.region-east
    name = "swarm-sg-east"
    description = "Allow traffic TCP/22 (SSH) from external IP"
    vpc_id = aws_vpc.vpc_east.id

    # SSH sessions in the console
    ingress {
        description = "Allow traffic from TCP/22 from public IP."
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow traffic between subnet 1 and subnet 2
    ingress {
        description = "Allow traffic between both subnets"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "10.0.1.0/24" , "10.0.2.0/24"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}