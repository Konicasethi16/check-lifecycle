/*
  AWS Linux Module to provision Instance
*/


// EC2 Instance Configuration
resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.subnet.id
  vpc_security_group_ids = [data.aws_security_group.linux-sg.id]
  user_data              = data.template_file.user_data.rendered
  iam_instance_profile   = var.iam_role
  key_name               = "${data.aws_iam_account_alias.account_name.account_alias}-${var.key_name_os}"

  // Tags of EC2 Instance
  tags = {
    environment       = var.environment
    hostname          = var.hostname
    Name              = var.hostname
    operatingsystem   = var.operatingsystem
    startstopschedule = var.startstopschedule
    serverrole        = var.serverrole
    applicationname   = var.applicationname
    applicationowner  = var.applicationowner
    criticality       = var.criticality
    backup            = var.backup
  }

  // EC2 Root Volume Configuration
  root_block_device {
    volume_size           = var.root_vol_size
    volume_type           = var.root_vol_type
    delete_on_termination = var.root_vol_deletion
    kms_key_id            = data.aws_kms_key.by_key_arn.key_id
    encrypted             = var.encryption
  }

  // Ignore Userdata and Tags Updates on Running Instances
  /*lifecycle {
    ignore_changes = [tags, user_data]
  }*/
  lifecycle {
    ignore_changes = all
  }
}

// Instance Secondary GP2 volumes Configuration
resource "aws_ebs_volume" "gp2_volume" {
  count             = length(var.sec_gp2_size)
  availability_zone = data.aws_subnet.subnet.availability_zone
  size              = element(var.sec_gp2_size, count.index)
  type              = var.sec_gp2_type
  kms_key_id        = data.aws_kms_key.by_key_arn.key_id
  encrypted         = var.encryption
  depends_on        = [aws_instance.ec2]
  lifecycle {
    ignore_changes = all
  }
}

// Instance Secondary IOPS volumes Configuration
resource "aws_ebs_volume" "iops_volume" {
  count             = length(var.sec_iops_size)
  availability_zone = data.aws_subnet.subnet.availability_zone
  size              = element(var.sec_iops_size, count.index)
  type              = element(var.sec_iops_type, count.index)
  iops              = element(var.sec_iops_value, count.index)
  kms_key_id        = data.aws_kms_key.by_key_arn.key_id
  encrypted         = var.encryption
  depends_on        = [aws_instance.ec2]
  lifecycle {
    ignore_changes = all
  }
}

// Attach Secondary GP2 volumes
resource "aws_volume_attachment" "gp2_vol_attach" {
  count        = length(var.sec_gp2_size)
  device_name  = "/dev/${var.sec_gp2_name[count.index]}"
  volume_id    = aws_ebs_volume.gp2_volume[count.index].id
  instance_id  = aws_instance.ec2.id
  force_detach = "true"
  lifecycle {
    ignore_changes = all
  }
}

// Attach Secondary IOPS volumes
resource "aws_volume_attachment" "iops_vol_attach" {
  count        = length(var.sec_iops_size)
  device_name  = "/dev/${var.sec_iops_name[count.index]}"
  volume_id    = aws_ebs_volume.iops_volume[count.index].id
  instance_id  = aws_instance.ec2.id
  force_detach = "true"
  lifecycle {
    ignore_changes = all
  }
}

// Create Route53 A record in Ericsson Default Hosted Zone
resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.hostname}.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ec2.private_ip]
  lifecycle {
    ignore_changes = all
  }
}
