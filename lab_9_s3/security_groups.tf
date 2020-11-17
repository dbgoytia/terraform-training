# Allow connectivity over port 22
resource "aws_security_group" "node-sg" {

  name        = "node-sg"
  description = "Allow TCP/22"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow 22 from public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = [var.external_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}