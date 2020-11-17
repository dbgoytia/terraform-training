provider "aws" {
  region = "us-east-1"
}

module "webserver_module" {
  source = "../modules/webserver/"

  instance-type = "t2.micro"
}