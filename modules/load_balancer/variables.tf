variable "alb_name" {
  description = "application load balancer name"
  default = "myALB"
}

variable "alb_target_group_name" {
  description = "ALB Target group name"
  default = "myALBTargetGroup"
}

variable "alb_vpc_id" {
  description = "application load balancer associated vpc id"
}

variable "alb_subnet_1" {
  description = "application load balancer subnet 1"
}

variable "alb_subnet_2" {
  description = "application load balancer subnet 2"
}

