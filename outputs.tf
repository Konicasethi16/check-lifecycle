/*
   AWS Linux Module Outputs
*/

output "private_ip" {
  description = "EC2 Instance Private IP"
  value       = aws_instance.ec2.private_ip
}

output "account_name" {
  description = "AWS Account Alias"
  value       = data.aws_iam_account_alias.account_name.account_alias
}
