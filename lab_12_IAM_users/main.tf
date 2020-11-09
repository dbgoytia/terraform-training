provider "aws" {
  region = "us-east-1"
}

# Create three users: 
#   * user-1 password: 123456
#   * user-2 password: 123456
#   * user-3 password: 123456

resource "aws_iam_user" "user-1" {
  name = "user-1"
}

resource "aws_iam_user" "user-2" {
  name = "user-2"
}

resource "aws_iam_user" "user-3" {
  name = "user-3"
}


# Create access keys for the three users
resource "aws_iam_access_key" "key-1" {
  user = aws_iam_user.user-1.name
}

resource "aws_iam_access_key" "key-2" {
  user = aws_iam_user.user-2.name
}

resource "aws_iam_access_key" "key-3" {
  user = aws_iam_user.user-3.name
}


# Create the three following groups
#   * user-1 should be in the S3-Support group.
#   * user-2 should be in the EC2-Support group.
#   * user-3 should be in the EC2-Admin group.
resource "aws_iam_group" "s3-support" {
  name = "s3-support"
}

resource "aws_iam_group" "ec2-support" {
  name = "ec2-support"
}

resource "aws_iam_group" "ec2-admin" {
  name = "ec2-admin"
}

resource "aws_iam_user_group_membership" "membership-1" {
  user = aws_iam_user.user-1.name
  groups = [
    aws_iam_group.s3-support.name,
  ]
}

resource "aws_iam_user_group_membership" "membership-2" {
  user = aws_iam_user.user-2.name
  groups = [
    aws_iam_group.ec2-support.name,
  ]
}


resource "aws_iam_user_group_membership" "membership-3" {
  user = aws_iam_user.user-3.name
  groups = [
    aws_iam_group.ec2-admin.name,
  ]
}

















