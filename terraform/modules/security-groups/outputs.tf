output "alb_sg_id" {
  description = "ALB security group ID — passed to the Load Balancer module"
  value       = aws_security_group.alb.id
}

output "ec2_sg_id" {
  description = "EC2 security group ID — passed to the EC2 module"
  value       = aws_security_group.ec2.id
}

output "rds_sg_id" {
  description = "RDS security group ID — passed to the RDS module"
  value       = aws_security_group.rds.id
}
