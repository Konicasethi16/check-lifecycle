/*
  AWS Linux DataSource configuration
*/

// Datasource block used to fetch VPC ID
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

// Fetch Subnet ID using VPC and Subnet Name
data "aws_subnet" "subnet" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
}

// Instance Userdata Templates
data "template_file" "user_data" {
  template = file("${path.module}/cloud-init.sh")
  vars = {
    akv_local_user_aws_linux_vm = var.akv_local_user_aws_linux_vm
  }
}

// Fetch Security Group ID through Security Group Name
data "aws_security_group" "linux-sg" {
  name = var.security_group
}

// Fetch Recent Updated AMI from Ericsson Private Cloud Images
data "aws_ami" "ami" {
  most_recent = true
  owners      = [var.ami_owner]
  filter {
    name   = "name"
    values = ["*${var.operatingsystem}*"]
  }
}

// Hosted Zone of Route53
data "aws_route53_zone" "selected" {
  name         = "${var.account_id}.${var.region}.ac.ericsson.se."
  private_zone = true
}

# // AWS Default KMS Alias for EBS
# data "aws_kms_alias" "ebs" {
#   name = var.kms_alias
# }

// AWS KMS ARN for EBS
data "aws_kms_key" "by_key_arn" {
  key_id = var.kms_key_id
}

// AWS Customer Account Name Alias
data "aws_iam_account_alias" "account_name" {}

