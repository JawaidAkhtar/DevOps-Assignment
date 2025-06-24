output "alb_arn" {
  value = aws_lb.app_alb.arn
}

output "alb_dns" {
  value = aws_lb.app_alb.dns_name
}

output "backend_tg_arn" {
  value = aws_lb_target_group.backend_tg.arn
}

output "frontend_tg_arn" {
  value = aws_lb_target_group.frontend_tg.arn
}
