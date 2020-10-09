terraform {
  required_version = ">=0.12.0"

  backend "s3" {
    region  = "us-west-2"
    profile = "default"
    key     = "terraformstatefile"
    bucket  = "terraformstatebucket-devops-training"
  }
}
