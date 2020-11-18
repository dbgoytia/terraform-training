provider "aws" {
  region = "us-east-1"
}

module "network" {
  source            = "../modules/networking/"
  vpc_cidr_block    = "10.0.0.0/16"
  cidr_block_subnet = "10.0.1.0/24"
}

module "instances" {
  source        = "../modules/instances/"
  instance-type = "t2.micro"
  key_pair_name = "dgoytia"
  key_pair_path = "~/.ssh/id_rsa.pub"
  vpc_id        = module.network.VPC_ID
  subnet_id     = module.network.SUBNET_ID
}

module "storage" {
  source                   = "../modules/storage/"
  subnet_availability_zone = module.network.SUBNET_AVAILABILITY_ZONE
  instance-id              = module.instances.INSTANCE_ID
}


