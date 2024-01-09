# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.my_vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_tag
  }
}

# Create Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_1_cidr
  availability_zone = var.az_1
  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_2_cidr
  availability_zone = var.az_2
  tags = {
    Name = "public_subnet_2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_1_cidr
  availability_zone = var.az_1
  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_2_cidr
  availability_zone = var.az_2
  tags = {
    Name = "private_subnet_2"
  }
}
