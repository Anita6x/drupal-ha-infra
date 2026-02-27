output "vpc_id" {
  description = "The VPC ID — used by security groups and other resources"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "The VPC IP range — used in security group rules"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  description = "Public subnet ID — EC2 and Load Balancer go here"
  value       = aws_subnet.public.id
}

output "private_subnet_a_id" {
  description = "Private subnet A ID — RDS goes here"
  value       = aws_subnet.private_a.id
}

output "private_subnet_b_id" {
  description = "Private subnet B ID — spare, required by RDS"
  value       = aws_subnet.private_b.id
}

output "db_subnet_group_name" {
  description = "RDS subnet group name — passed directly to the RDS module"
  value       = aws_db_subnet_group.main.name
}

output "public_subnet_b_id" {
  description = "Second public subnet ID — required by ALB"
  value       = aws_subnet.public_b.id
}
