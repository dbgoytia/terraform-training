# Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "JenkinsMasterAMI" {
    provider = aws.region-east
    name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Get Linux AMI ID using SSM Parameter endpoint in us-west-2
data "aws_ssm_parameter" "JenkinsWorkerAMI" {
    provider = aws.region-west
    name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Create key-pair for logging into EC2 instances us-east-1
resource "aws_key_pair" "master-key" {
    provider = aws.region-east
    key_name = "jenkins"
    public_key = file("~/Documents/CMM/Training/Terraform/lab_2_vm_provisioning_alb/.ssh/id_rsa.pub")
}

# Create a key-pair for logginf into EC2 instance us-west-2
resource "aws_key_pair" "worker-key" {
    provider = aws.region-west
    key_name = "jenkins"
    public_key = file("~/Documents/CMM/Training/Terraform/lab_2_vm_provisioning_alb/.ssh/id_rsa.pub")
}

# Create EC2 instance in us-east-1
resource "aws_instance" "jenkins-master" {
    provider = aws.region-east
    ami = data.aws_ssm_parameter.JenkinsMasterAMI.value
    instance_type = var.instance-type
    key_name = aws_key_pair.master-key.key_name
    associate_public_ip_address = true
    vpc_security_group_ids      = [aws_security_group.jenkins-sg-east.id]
    subnet_id                   = aws_subnet.subnet_1_east.id

    tags = {
        Name = "jenkins-master-tf"
    }
    
    provisioner "local-exec" {
        command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-east} --instance-ids ${self.id} \
&& ansible-playbook --extra-vars 'passed_in_hosts=${self.tags.Name}' ansible_templates/install_jenkins.yaml
EOF
    }

    depends_on = [aws_main_route_table_association.set-east-region-rt-assoc]
}

# Create EC2 instance in us-west-2
resource "aws_instance" "jenkins-workers" {
    provider = aws.region-west
    count = var.workers-count
    ami = data.aws_ssm_parameter.JenkinsWorkerAMI.value
    instance_type = var.instance-type
    key_name = aws_key_pair.worker-key.key_name
    associate_public_ip_address = true
    vpc_security_group_ids      = [aws_security_group.jenkins-sg-west.id]
    subnet_id                   = aws_subnet.subnet_1_west.id
  provisioner "remote-exec" {
    when = destroy
    inline = [
      "java -jar /home/ec2-user/jenkins-cli.jar -auth @/home/ec2-user/jenkins_auth -s http://${aws_instance.jenkins-master.private_ip}:8080 -auth @/home/ec2-user/jenkins_auth delete-node ${self.private_ip}"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/Documents/CMM/Training/Terraform/lab_2_vm_provisioning_alb/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-west} --instance-ids ${self.id} \
&& ansible-playbook --extra-vars 'passed_in_hosts=${self.tags.Name} master_ip=${aws_instance.jenkins-master.private_ip}' ansible_templates/install_worker.yaml
EOF
  }
  tags = {
    Name = join("_", ["jenkins_worker_tf", count.index + 1])
  }
  depends_on = [aws_main_route_table_association.set-west-region-rt-assoc, aws_instance.jenkins-master]
}