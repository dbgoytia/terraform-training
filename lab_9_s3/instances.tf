# Obtain AMI for latest Ubuntu version available
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical

}

# Add ssh key on creation time for loggin into the instance
resource "aws_key_pair" "key" {
  key_name   = "key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create the Ubuntu instance and attach the subnet and key-pair
resource "aws_instance" "instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance-type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet.id
  key_name                    = aws_key_pair.key.key_name
  vpc_security_group_ids      = [aws_security_group.node-sg.id]
  tags = {
    Name = "s3-test-compute"
  }
  depends_on = [aws_route_table_association.rt-assoc]
}