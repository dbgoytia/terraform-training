provider "aws" {
  profile = var.profile
  region  = var.region-east
  alias   = "region-east"
}

provider "aws" {
  profile = var.profile
  region  = var.region-west
  alias   = "region-west"
}
