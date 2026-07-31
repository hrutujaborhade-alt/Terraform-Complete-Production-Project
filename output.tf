output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_arn" {
  value = module.alb.alb_arn
}

output "asg_name" {
  value = module.autoscaling.asg_name
}