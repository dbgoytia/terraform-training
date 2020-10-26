provider "aws" {
  profile = var.profile
  region  = var.region-east
  alias   = "region-east"
  version = "~> 2.52"
}