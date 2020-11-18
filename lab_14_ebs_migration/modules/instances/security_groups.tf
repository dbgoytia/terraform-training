resource "aws_security_group" "allow_webserver" {

  name = "allow_webserver_traffic"

  description = "Allows traffic for webserver and ssh port"

  vpc_id      = var.vpc_id


  ingress {
    description = "Allow ssh on port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow traffic from http port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Lab = "EBS migration lab"
  }
}