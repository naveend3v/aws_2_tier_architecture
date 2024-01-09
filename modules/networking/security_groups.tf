locals {
  inbound_ports  = [22, 80, 443]
  outbound_ports = [0]
}

# Create Security Groups
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "ec2 security group"
  vpc_id      = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = toset(local.inbound_ports)
    content {
      description = "Inbound from alb/internet"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = toset(local.outbound_ports)
    content {
      description = "Outbound to VPC"
      from_port   = egress.value
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name = "ec2_sg"
  }
}

resource "aws_security_group" "rds_ec2_sg" {
  name = "rds_ec2_sg"
  description = "ec2 to rds inbound connection"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    description      = "Inbound connection from ec2 instance"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    description = "Outbound from VPC"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_ec2_sg"
  }
}

