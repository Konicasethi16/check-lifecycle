/*
  AWS Linux Module Variables
*/

// Instance Variables
variable "account_id" {
  type        = string
  description = "AWS Account ID to provision VM"
  default     = "323533494701"
}

variable "region" {
  type        = string
  description = "AWS Region to provision VM"
  default     = "eu-west-1"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name to provision VM"
  default     = "vpc-0cca2e67"
}

variable "subnet_name" {
  type        = string
  description = "Subnet Name to provision VM"
  default     = "subnet-427e732a"
}

variable "security_group" {
  type        = string
  description = "Security Group to attach"
  default     = "sg-1c902078"
}

variable "ami_owner" {
  type        = string
  description = "ID of AMI owner to use for the instance"
  default     = "323533494701"
}

variable "operatingsystem" {
  type        = string
  description = "Operating System of VM"
  default     = "ubuntu"
}

variable "instance_type" {
  type        = string
  description = "Type of instance to start"
  default     = "t3.xlarge"
}

variable "hostname" {
  type        = string
  description = "Hostname of the VM"
  default     = "test-lifecycle"
}

variable "key_name_os" {
  type        = string
  description = "Key Name to use for the instance"
  default     = "konica-tfe-kub-mum.pem"
}

variable "kms_key_id" {
  type        = string
  description = "KMS Key to encrypt the instance disk"
  default     = "c5cf0d2c-4f8d-4675-8bcc-ff9b5b040359"
}

variable "akv_local_user_aws_linux_vm" {
  type        = string
  description = "Local Linux User Password"
  default     = "konica"
}

variable "iam_role" {
  type        = string
  description = "IAM Role to assign to the VM"
  default     = "AmazonEC2RoleforSSM"
}

// Root Volume Variables
variable "encryption" {
  type        = string
  description = "If true, the EC2 instance Disk will be encrypted"
  default     = "true"
}

variable "root_vol_size" {
  type        = string
  description = "Root Volume Size of Instance"
  default     = "50"
}

variable "root_vol_type" {
  type        = string
  description = "Root Volume Type of Instance"
  default     = "gp2"
}

variable "root_vol_deletion" {
  type        = string
  description = "If true, the EC2 instance Root Volume will delete on termination"
  default     = "true"
}

// Secondary Volume Variables
variable "sec_gp2_size" {
  type        = list(string)
  description = "GP2 Disk Size of Instance"
  default     = [50]
}

variable "sec_gp2_type" {
  type        = string
  description = "Secondary GP2 Disk Type"
  default     = "gp2"
}

variable "sec_gp2_name" {
  type        = list(string)
  description = "Array of Secondary GP2 Disk Name"
  default     = ["xvde", "xvdf", "xvdg", "xvdh", "xvdi", "xvdj", "xvdk", "xvdl", "xvdm", "xvdn"]
}

variable "sec_iops_size" {
  type        = list(string)
  description = "Array of Secondary IOPS Disk Size"
  default     = [50]
}

variable "sec_iops_type" {
  type        = list(string)
  description = "Array of Secondary IOPS Disk Type"
  default     = ["gp2"]
}

variable "sec_iops_value" {
  type        = list(string)
  description = "Array of Secondary IOPS Disk Value"
  default     = [1000]
}

variable "sec_iops_name" {
  type        = list(string)
  description = "Array of Secondary IOPS Disk Names"
  default     = ["xvdo", "xvdp", "xvdq", "xvdr", "xvds", "xvdt", "xvdu", "xvdv", "xvdw", "xvdx"]
}

// Instance Tag Variables
variable "environment" {
  type        = string
  description = "Environment Tag"
  default     = "test"
}

variable "startstopschedule" {
  type        = string
  description = "Instance Start-Stop Schedule"
  default     = "null"
}

variable "serverrole" {
  type        = string
  description = "Instance Server Role"
  default     = "aws_cli_ec2"
}

variable "criticality" {
  type        = string
  description = "Instance Server Criticality"
  default     = "high"
}

variable "applicationname" {
  type        = string
  description = "Instance Application Name"
  default     = "edcs"
}

variable "applicationowner" {
  type        = string
  description = "Instance Application Owner"
  default     = "konica"
}

variable "backup" {
  type        = string
  description = "If true, the EC2 instance backup will be enabled"
  default     = "true"
}
