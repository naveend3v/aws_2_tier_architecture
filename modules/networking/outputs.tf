output "ec2_sg_id" {
  description = "ec2 security group id"
  value = aws_security_group.ec2_sg.id
}

output "rds_ec2_sg_id" {
  description = "rds to ec2 security group id"
  value = aws_security_group.rds_ec2_sg.id
}

output "public_subnet_1" {
  description = "public subnet 1"
  value = aws_subnet.public_subnet_1.id
}

output "public_subnet_2" {
  description = "public subnet 2"
  value = aws_subnet.public_subnet_2.id
}


output "private_subnet_1" {
  description = "private subnet 1"
  value = aws_subnet.private_subnet_1.id
}

output "private_subnet_2" {
  description = "private subnet 2"
  value = aws_subnet.private_subnet_2.id
}

output "vpc_id" {
  description = "vpc id"
  value = aws_vpc.my_vpc.id
}


output "availability_zone_1" {
  description = "Availability zone 1"
  value = var.az_1
}

output "availability_zone_2" {
  description = "Availability zone 2"
  value = var.az_2
}
