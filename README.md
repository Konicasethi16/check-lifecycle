# Ericsson terraform module: terraform-aws-linux


# Introduction:
This Terraform module deploys RHEL VM in AWS with the following characteristics:

# Features:

  1. Provision AWS RHEL VM in provided AWS account based on User Input and using standard resources.
  2. Create secondary volumes and attach after instance deployment
  3. Create secondary IOPS volumes and attach after instance deployment
  4. Create Route53 A Record for Instance Hostname and for all aliases.

# Onboarding Prerequisites:
Below is the list of requirement need to complete during account onboarding

  | Requirement | Description | Solution | Pre-requisite | Part of Account Onboarding | Responsibility |
  |-------------|-------------|:--------:|:-------------:|:--------------------------:|:--------------:|
  | AWS Account | Hosting Zone availability for DNS entry of terraform provisioned VMs on AWS | Control and Ops plane checks should be completed and Handed over to application for production use. | Out of Scope for IAC | Yes | Ericsson Control Plane, HCL Ops plane, and HCL Operation Team |
  | PaloAlto Firewall | Firewall ports to be opened for seamless connection between Ansible and terraform accounts to Target AWS account VMs | Generalize firewall Rules should be implemented. This should be one time activity | Firewall ports for winrm(5985/5986) and ssh(22) are opened at palo alto side for all the application account hosted on AWS. This has been tested and verified by IAC team on couple of account | NA | Ericsson N/W security |
  | AWS Security Group(IAC-winrm/ssh) | To setup communication channel between IAC tools to remote machines   | SG rules specific to winrm/ssh(5985/5986/22/ICMP) should be added | sg_app security group should be available in all the application accounts | Yes | HCL-OPS Plane Team/HCL Operation |
  | Cloud Account Access | Assume identity for terraform/SPN Based Access | cloud formation template to used for role creation and should be added in every target account to be managed | All the AWS application account should have role **Terraform-AutomationExecutionRole**<br /> **Note:** *Make sure this Role should have all the required policies(Ex: AmazonEC2FullAccess etc.) attached to perform provisioning on respective AWS Accounts* | Yes | HCL-OPS Plane Team/HCL Operation |
  | CloudAccess (Domain Join/other activity) | Service account access on target IDM or security Group(power user access atleast | IDM - idm request for service account access during account onboarding. HCL Ops plane and cloud operation team will request Administrator IDM access for given service account whenever a new account is onboarded | Ansible service account **sawxegad** should be given admin access on target account. VM provisioning will fail in absence of this | Yes | HCL-OPS team/HCL Operation |
  | Key-Pair | key pair are required during server provisioning | Key pair for windows/Linux()standard naming should pre available and created at the time of account onboarding | AWS Ops plane/ AWS Operation to add the suggested key-pair at the time of Account onboarding. All in small character like **accountname-linux** and **accountname-windows** | Yes | HCL-OPS plane/HCL Cloud Operation |
  | KMS | KMS for Encryption | Ericsson managed KMS key should be used | 1. Use below link to generate KMS key [KMS Link](https://ericsson-dwp.onbmc.com/dwp/rest/share/OJSXG33VOJRWKVDZOBST2U2CL5IFET2GJFGwhvsspro4eesk44ecnijxcsol546oh6dwstt7hsislxd44khzb2awhvsspro4eesk44ecnijxcsol546oh6dwstt7hsislxd44khzb2aEKJTUMVXGC3TUJFSD2MBQGAYDAMBQGAYDAMBQGAYDCJTSMVZW65LSMNSUSZB5GM3DKMJUEZRW63TUMV4HIVDZOBST2Q2BKRAUYT2HL5EE6TKF)<br />2. Request service using MY support | No | Service Requestor |

# Unit Test Prerequisites:
Following Steps need to be performed, In order to perform unit testing on the Terraform CLI.

  1. Install and Configure Terraform CLI Binary on the local machine.
  2. Terraform will assume IAM role "Terraform-AutomationExecutionRole" to provision resources on provided account.


# Getting Started

## Software dependencies

None

## Hardware dependencies

None

## Version Constraints

### Terraform Version

| Name | Compatible Version |
|------|--------------------|
|terraform | 0.15.3         |

### Provider Version

| Name | Compatible Version |
|------|--------------------|
|aws | 3.68.0             |

## Build & Test

### Clone Terraform Module

```
git clone https://EricssonInfraIAC@dev.azure.com/EricssonInfraIAC/IT4IT_Ansible_Terraform_Core/_git/terraform-aws-linux
```

### Move to the Terraform Directory

```
cd terraform-aws-linux
```

### Initializing the Environment

```
terraform init
```

### Planning the configuration

```
terraform plan
```

## Running the configuration
```
terraform apply
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| account_id | AWS Account ID | `string` | n/a | yes |
| region | AWS Region to provision VM | `string` | n/a | yes |
| vpc_name | VPC Name to provision VM | `string` | n/a | yes |
| subnet_name | Subnet Name to provision VM | `string` | n/a | yes |
| security_group | Security Group to attach | `string` | n/a | yes |
| ami_owner | Account ID of AMI owner to use for the instance | `string` | n/a | yes |
| operatingsystem  | Operating System of VM | `string` | n/a | yes |
| instance_type  | Type of instance to start | `string` | n/a | yes |
| hostname | Hostname of the VM | `string` | n/a | yes |
| key_name_os | Key Name to use for the instance | `string` | n/a | yes |
| kms_key_id | KMS ARN to encrypt the instance disk | `string` | n/a | yes |
| akv_local_user_aws_linux_vm | Local Linux User Password | `string` | n/a | yes |
| iam_role | IAM Role to assign to the VM | `string` | `AmazonEC2RoleforSSM` | yes |
| encryption | If true, the EC2 instance Disk will be encrypted | `bool` | `true` | yes |
| root_vol_size | Root Volume Size of Instance | `string` | n/a | yes |
| root_vol_type | Root Volume Type of Instance | `string` | `gp2` | yes |
| root_vol_deletion | If true, the EC2 instance Root Volume will delete on termination | `bool` | `true` | yes |
| sec_gp2_size | GP2 Disk Size of Instance | `string` | n/a | yes |
| sec_gp2_type | Secondary GP2 Disk Type | `string` | `gp2` | yes |
| sec_gp2_name | Array of Secondary GP2 Disk Name | `list(string)` | n/a | yes |
| sec_iops_size | Array of Secondary IOPS Disk Size | `string` | n/a | yes |
| sec_iops_type | Array of Secondary IOPS Disk Type | `string` | n/a | yes |
| sec_iops_value | Array of Secondary IOPS Disk Value | `string` | n/a | yes |
| sec_iops_name | Array of Secondary IOPS Disk Names | `list(string)` | n/a | yes |
| environment | VM Environment Tag | `string` | n/a | yes |
| startstopschedule | Instance Start-Stop Schedule | `string` | n/a | yes |
| serverrole | Instance Server Role | `string` | n/a | yes |
| criticality | Instance Server Criticality | `string` | n/a | yes |
| applicationname | Instance Application Name | `string` | n/a | yes |
| applicationowner | Instance Application Owner | `string` | n/a | yes |
| backup | Backup Frequency | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| private_ip | Output of the AWS EC2 Instance Private IP |
| account_name | Output of the AWS Account Alias |

# Usage Sample Code

```hcl

// RHEL VM Template
module "aws_instance_ACWEULX0080_REQ01234" {
  source                      = "terraform-dev-groupit.internal.ericsson.com/Ericsson/linux/aws"
  version                     = "1.0.12"
  account_id                  = "847066372451"
  region                      = "eu-west-1"
  vpc_name                    = "ECN-VPC"
  subnet_name                 = "ECN-PrivateSubnet1"
  security_group              = "sg_app"
  ami_owner                   = "430170170793"
  operatingsystem             = "Ericsson RHEL 7"
  instance_type               = "t2.micro"
  hostname                    = "ACWEULX0080"
  root_vol_size               = "10"
  root_vol_type               = "gp2"
  sec_gp2_size                = [10]
  sec_iops_size               = [10]
  sec_iops_type               = ["gp3"]
  sec_iops_value              = [3000]
  key_name_os                 = "linux"
  kms_key_id                  = "%%KMS_KEY_ID%%"
  iam_role                    = "AmazonEC2RoleforSSM"
  akv_local_user_aws_linux_vm = var.akv_local_user_aws_linux_vm
  environment                 = "DEV"
  startstopschedule           = "24*7"
  serverrole                  = "app"
  criticality                 = ""
  applicationname             = "terraform enterprise"
  applicationowner            = "tfe@ericsson.com"
  backup                      = "daily at 8pm cet"
}

output "OUTPUT_ACWEULX0080_REQ01234_IP" {
  value = module.aws_instance_ACWEULX0080_REQ01234.private_ip
}

output "OUTPUT_ACWEULX0080_REQ01234_ACCOUNT" {
  value = module.aws_instance_ACWEULX0080_REQ01234.account_name
}
