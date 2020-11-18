# Output the instance public ip
output "INSTANCE_PUBLIC_IP" {
  value = aws_instance.webserver.public_ip
}

output "INSTANCE_ID" {
  value = aws_instance.webserver.id
}