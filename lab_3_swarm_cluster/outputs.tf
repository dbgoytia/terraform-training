# Output the public IP's of the master nodes
output "Swarm-Manager-Public-IP" {
    value = aws_instance.swarm_manager.public_ip
}

# Output the public IP's of the master nodes
output "Swarm-Manager-Private-IP" {
    value = aws_instance.swarm_manager.private_ip
}

# Output the public IP's of the worker nodes
output "Swarm-Workers-Public-IPs" {
    value = {
        for instance in aws_instance.swarm_nodes:
            instance.id => instance.public_ip
    }
}

# Output the private IP's of the worker nodes
output "Swarm-Workers-Private-IPs" {
    value = {
        for instance in aws_instance.swarm_nodes:
            instance.id => instance.private_ip
    }
}

