# Get Amazon Linux AMI image ID
data "aws_ssm_parameter" "amazon_linux_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Create a key-pair for loggin into our instance
resource "aws_key_pair" "webserver-key" {
  key_name   = var.key_pair_name
  public_key = file(var.key_pair_path)
}

# Create the instance
resource "aws_instance" "webserver" {
  # Use retrevied amazon ID.
  ami = data.aws_ssm_parameter.amazon_linux_ami.value

  # Make the instance publicly accessible
  associate_public_ip_address = true

  # Instance type to be deployed
  instance_type = var.instance-type

  # Attach keypair to login to the instance
  key_name = aws_key_pair.webserver-key.key_name

  # Attach security group
  vpc_security_group_ids = [aws_security_group.allow_webserver.id]

  # Attach the subnet created in the networking module
  subnet_id = var.subnet_id
  
  tags = {
    Lab = "EBS migration lab"
  }
}