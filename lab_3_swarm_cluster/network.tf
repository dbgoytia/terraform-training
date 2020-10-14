#############################
###  NETWORK PROVISIONING ###
#############################


module "vpc" {

    source = "terraform-aws-modules/vpc/aws"

    name = "vpc-swarm"

    cidr = "10.0.0.0/16"
 
    azs             = [element(data.aws_availability_zones.azs.names, 0), element(data.aws_availability_zones.azs.names, 1)]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

    enable_nat_gateway = true
    single_nat_gateway = true
    
    enable_vpn_gateway = true

    tags = {
        Terraform = "true"
        Environment = "dev"
        Owner = "DevOps"
    }

}