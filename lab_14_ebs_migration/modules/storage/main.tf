# Provision an EBS volume for our instance
resource "aws_ebs_volume" "dev-sdh" {
  availability_zone = var.subnet_availability_zone
  size              = 40

  tags = {
    Lab = "EBS migration lab"
  }
}

# Attach the storage device to the instance
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.dev-sdh.id
  instance_id = var.instance-id
}