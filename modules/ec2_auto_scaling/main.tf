# Create Launch Template
resource "aws_launch_template" "ec2_launch_template" {
  name                   = "ec2_launch_template"
  description            = "launch template for ec2"
  image_id               = var.ec2_instance_ami
  instance_type          = var.ec2_instance_type
  user_data              = filebase64("${path.module}/user_data.sh")
  key_name               = aws_key_pair.public_rsa_key.key_name

  network_interfaces {
  associate_public_ip_address = true
  delete_on_termination = true
  security_groups = [var.ec2_security_group]
}

  iam_instance_profile {
    name = var.ec2_instance_profile
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      # Size of the EBS volume in GB
      volume_size = 8

      # Type of EBS volume (General Purpose SSD in this case)
      volume_type = "gp2"
    }
  }
  # Tag specifications for the instance
  tag_specifications {
    # Specifies the resource type as "instance"
    resource_type = "instance"

    tags = {
      Name = "ec2-instance"
    }
  }
}

# Create private ssh key for ec2 instance for ssh connection
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create ssh public key pair
resource "aws_key_pair" "public_rsa_key" {
  key_name   = "public_rsa_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Downloading private key pair to local windows machine
resource "local_file" "private_rsa_key" {
  filename        = "ssh_private_rsa_key.pem"
  file_permission = "0400"
  content         = tls_private_key.ssh_key.private_key_pem
}

# Create Auto Scaling group
resource "aws_autoscaling_group" "asg" {
  name                      = var.asg_name
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = var.asg_desired_capacity
  force_delete              = true
  vpc_zone_identifier       = [var.asg_subnet_1, var.asg_subnet_2]
  target_group_arns         = [var.alb_target_group_arn]
  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }
}

# Attach the Auto Scaling Group to the Application Load Balancer's Target Group.
resource "aws_autoscaling_attachment" "asg_tg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = var.alb_target_group_arn
}
