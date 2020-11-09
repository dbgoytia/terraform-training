provider "aws" {
    region = "us-east-1"
}

module "static_site_mod" {
  source = "../modules/static-website/"

  bucket-name  = "static-website-lab"
  acl-kind      = "public-read"
  environment = "stage"
}