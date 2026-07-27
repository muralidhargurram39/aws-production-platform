output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "application_security_group_id" {
  value = aws_security_group.application.id
}

output "database_security_group_id" {
  value = aws_security_group.database.id
}

output "management_security_group_id" {
  value = aws_security_group.management.id
}
