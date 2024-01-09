output "alb_tg_arn" {
  description = "alb target group arn"
  value = aws_lb_target_group.alb_target_group.arn
}

output "alb_dns_name" {
  description = "alb dns name"
  value = aws_lb.alb.dns_name
}
