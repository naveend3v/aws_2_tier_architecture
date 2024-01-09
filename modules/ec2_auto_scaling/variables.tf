variable "ec2_instance_ami" {
  description = "AWS EC2 AMI ID"
  default = "ami-0c7217cdde317cfec"
}

variable "ec2_instance_type" {
  description = "AWS EC2 instance type"
  default = "t2.micro"
}

variable "ec2_instance_profile" {
  description = "AWS EC2 instance profile"
}

variable "ec2_security_group" {
  description = "AWS EC2 instance profile"
  type = string
}

variable "asg_name" {
  description = "Auto scaling group name"
  default = "my_asg"
}

variable "asg_subnet_1" {
  description = "Auto scaling group subnet 1"
}

variable "asg_subnet_2" {
  description = "Auto scaling group subnet 2"
}

variable "alb_target_group_arn" {
  description = "ALB target group arn"
  type = string
}

variable "asg_min_size" {
  description = "Auto scaling group minimum size"
}

variable "asg_max_size" {
  description = "Auto scaling group maximum size"
}

variable "asg_desired_capacity" {
  description = "Auto scaling group desired capacity"
}