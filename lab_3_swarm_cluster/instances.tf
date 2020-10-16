# Linux AMI using SSM Parameter endpoint in us-east-1
# This image will be used accross the master and the N slaves.
data "aws_ssm_parameter" "SwarmAMI" {
    provider = aws.region-east
    name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


# SSH key-pair for logging into EC2 instances in us-east-1
resource "aws_key_pair" "swarm-key" {
    provider = aws.region-east
    key_name = "docker-swarm"
    public_key = file("~/.ssh/id_rsa2.pub")
}

# Manager instance
resource "aws_instance" "swarm_manager" {
    provider = aws.region-east
    ami = data.aws_ssm_parameter.SwarmAMI.value
    instance_type = var.instance-type
    key_name = aws_key_pair.swarm-key.key_name
    associate_public_ip_address = true
    subnet_id =  aws_subnet.public_manager.id
    vpc_security_group_ids = [aws_security_group.swarm-sg-east.id]
    tags = {
        Name = "swarm_manager_tf"
    }

    provisioner "local-exec" {
        command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-east} --instance-ids ${self.id} \
&& ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/install_swarm.yaml
EOF
    }

    depends_on = [aws_main_route_table_association.set-east-region-assoc]
}

# Worker nodes
resource "aws_instance" "swarm_nodes" {
    provider = aws.region-east
    count = var.workers-count
    ami = data.aws_ssm_parameter.SwarmAMI.value
    instance_type = var.instance-type
    key_name = aws_key_pair.swarm-key.key_name
    associate_public_ip_address = true
    subnet_id = aws_subnet.public_workers.id
    vpc_security_group_ids = [aws_security_group.swarm-sg-east.id]
    tags = {
        Name = join("_" , ["swarm_nodes_tf", count.index + 1])
    }

    depends_on = [aws_main_route_table_association.set-east-region-assoc, aws_instance.swarm_manager]
}


