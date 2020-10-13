# Configuration for the jenkins master:
# Allow TCP/8080 from * and TCP/22 from IP in us-east-1

resource "aws_security_group" "jenkins-sg-east" {
    provider = aws.region-east
    name = "jenkins-sg"
    description = "Allow TCP/22 from IG external IP"
    vpc_id = aws_vpc.vpc_east.id
    
    ingress {
        description = "Allow TCP/22 from our public IP"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow TCP/8080 from *"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow traffic from us-west-2"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["192.168.1.0/24"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }   
}

# Create a SG for the load balancer ofr us-east-1
resource "aws_security_group" "lb-sg" {
    provider = aws.region-east 
    vpc_id = aws_vpc.vpc_east.id
    name = "lb-sg"
ingress {
    description = "Allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 80 from anywhere for redirection"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "Allow traffic to jenkins-sg"
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins-sg-east.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create SG for traffic in us-west-2
resource "aws_security_group" "jenkins-sg-west" {
  provider = aws.region-west

  name        = "jenkins-sg-oregon"
  description = "Allow TCP/8080 & TCP/22"
  vpc_id      = aws_vpc.vpc_west.id
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow traffic from us-east-1"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}









