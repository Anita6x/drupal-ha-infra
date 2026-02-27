variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "environment" {
  description = "dev or staging"
  type        = string
}

variable "vpc_id" {
  description = "VPC to create the Load Balancer in"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet for the Load Balancer"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group for the Load Balancer"
  type        = string
}

variable "ec2_instance_id" {
  description = "EC2 instance to register as a target"
  type        = string
}

variable "public_subnet_b_id" {
  description = "Second public subnet in AZ-B — required by ALB"
  type        = string
}
