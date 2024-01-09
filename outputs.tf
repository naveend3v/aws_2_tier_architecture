output "application_url" {
  description = "application access url"
  value       = module.load_balancer.alb_dns_name
}