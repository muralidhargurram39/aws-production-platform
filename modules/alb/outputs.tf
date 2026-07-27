output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.application.arn
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.application.dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the ALB"
  value       = aws_lb.application.zone_id
}

output "target_group_arn" {
  description = "Application Target Group ARN"
  value       = aws_lb_target_group.application.arn
}

output "target_group_name" {
  description = "Application Target Group name"
  value       = aws_lb_target_group.application.name
}

output "alb_arn_suffix" {
  description = "ARN suffix of the Application Load Balancer."

  value = aws_lb.application.arn_suffix
}

output "target_group_arn_suffix" {
  description = "ARN suffix of the Target Group."

  value = aws_lb_target_group.application.arn_suffix
}
