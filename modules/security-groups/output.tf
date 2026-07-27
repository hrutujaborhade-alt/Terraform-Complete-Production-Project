output "ALB-security-group" {
  value = aws_security_group.alb_sg.id
}

output "EC2-security-group" {
  value = aws_security_group.ec2_sg.id
}

output "RDS-security-group" {
  value = aws_security_group.rds_sg.id
}