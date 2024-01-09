variable "my_vpc_cidr" {
  description = "CIDR Block for VPC"
  default = "10.0.0.0/16"
}

variable "vpc_tag" {
  description = "AWS 2 tier architecture"
}

variable "public_subnet_1_cidr" {
  description = "public subnet 1 cidr block"
  default = "10.0.1.0/24"

}

variable "public_subnet_2_cidr" {
  description = "public subnet 2 cidr block"
  default = "10.0.2.0/24"
}


variable "private_subnet_1_cidr" {
  description = "private subnet 1 cidr block"
  default = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "private subnet 2 cidr block"
  default = "10.0.4.0/24"
}

variable "az_1" {
description = "availability zone"
default = "us-east-1a"
}

variable "az_2" {
description = "availability zone"
default = "us-east-1b"
}

variable "ec2_security_group_id" {
  description = "ec2 security group id"
  type = string
}
