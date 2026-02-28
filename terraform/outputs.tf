output "vpc_id" {
  description = "Your VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet — EC2 and Load Balancer go here"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_a_id" {
  description = "Private subnet A — RDS goes here"
  value       = module.vpc.private_subnet_a_id
}

output "db_subnet_group_name" {
  description = "RDS subnet group name"
  value       = module.vpc.db_subnet_group_name
}

output "alb_sg_id" {
  description = "ALB security group ID"
  value       = module.security_groups.alb_sg_id
}

output "ec2_sg_id" {
  description = "EC2 security group ID"
  value       = module.security_groups.ec2_sg_id
}

output "rds_sg_id" {
  description = "RDS security group ID"
  value       = module.security_groups.rds_sg_id
}

output "ec2_public_ip" {
  description = "EC2 public IP — use this to SSH in"
  value       = module.ec2.public_ip
}

output "ec2_public_dns" {
  description = "EC2 public DNS name"
  value       = module.ec2.public_dns
}

output "db_host" {
  description = "RDS database host — used by Drupal to connect"
  value       = module.rds.db_host
  sensitive   = true
}

output "db_port" {
  description = "MySQL port"
  value       = module.rds.db_port
}

output "db_name" {
  description = "Database name"
  value       = module.rds.db_name
}

output "alb_dns_name" {
  description = "Your Drupal site URL — paste this into your browser!"
  value       = module.alb.alb_dns_name
}

output "dashboard_url" {
  description = "CloudWatch dashboard URL"
  value       = module.monitoring.dashboard_url
}
