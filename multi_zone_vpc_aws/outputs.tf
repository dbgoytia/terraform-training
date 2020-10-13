
output "Jenkins-Main-Node-Public-IP" {
  value = aws_instance.jenkins-master.public_ip
}

output "Jenkins-Worker-Public-IPs" {
  value = {
    for instance in aws_instance.jenkins-worker-oregon :
    instance.id => instance.public_ip
  }
}
<<<<<<< HEAD
=======

output "LB-DNS-NAME" {
  value = aws_lb.application-lb.dns_name
}
>>>>>>> 01e8465039e5cd698303c73d52e9c3162a28710f
