# Output the instance public ip
output "Instance_public_ip" {
  value = aws_instance.webserver.public_ip
}