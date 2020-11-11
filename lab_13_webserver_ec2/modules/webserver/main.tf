terraform {
  required_version = ">= 0.12, < 0.13"
}

# Get Linux AMI ID using SSM
data "aws_ssm_parameter" "amazon-linux-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Create key-pair for logging into our webserver
resource "aws_key_pair" "webserver-key" {
  key_name   = "dgoytia"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create the webserver
resource "aws_instance" "webserver" {

  # Use the retreived amazon latest image
  ami = data.aws_ssm_parameter.amazon-linux-ami.value

  # Make the instance publicly accesible
  associate_public_ip_address = true

  # Instance type to be deployed
  instance_type = var.instance-type

  # Attach a key_pair to log into the instance
  key_name = aws_key_pair.webserver-key.key_name

  # Attach security group
  vpc_security_group_ids      = [aws_security_group.allow_webserver.id]

  # Important tags to keep track of anything
  tags = {
    Department = "R&D"
    Owner      = "Diego Goytia"
  }
}