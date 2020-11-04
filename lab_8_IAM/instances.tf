# Create an EC2 Instance Profile
resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.test_role.name
}

# Get Linux AMI ID using SSM Parameter endpoint in us-east-1 for jenkins master
data "aws_ssm_parameter" "linuxAmi" {
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


# Create key-pairs for logging into EC2 in us-east-1
resource "aws_key_pair" "node-key" {
  key_name   = "dgoytia"
  public_key = file("~/.ssh/id_rsa.pub")
}


# Create AWS Instance
resource "aws_instance" "role-test" {
  ami                  = data.aws_ssm_parameter.linuxAmi.value
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  key_name             = aws_key_pair.node-key.key_name
  tags = {
      Name = "test-roles-SSA"
  }
}