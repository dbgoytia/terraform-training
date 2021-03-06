output "Jenkins-Master-AMI-ID" {
  value = data.aws_ssm_parameter.JenkinsMasterAMI.value
}

output "Jenkins-Worker-AMI-ID" {
  value = data.aws_ssm_parameter.JenkinsWorkerAMI.value
}
output "Jenkins-Master-Private-IP" {
  value = aws_instance.jenkins-master.private_ip
}
output "Jenkins-Worker-Public-IPs" {
  value = {
    for instance in aws_instance.jenkins-workers:
    instance.id => instance.public_ip
  }
}
output "Jenkins-Worker-Private-IPs" {
  value = {
    for instance in aws_instance.jenkins-workers :
    instance.id => instance.private_ip
  }
}

output "Loadbalancer-DNS-URL" {
  value = aws_lb.application-lb.dns_name
}
