variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "environment" {
  description = "staging or production"
  type        = string
}

variable "vpc_cidr" {
  description = "IP range for the entire VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "IP range for the public subnet — EC2 and Load Balancer live here"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "IP range for private subnet A — RDS MySQL lives here"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_b" {
  description = "IP range for private subnet B — required by RDS, nothing deployed here"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone_a" {
  description = "Primary availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_b" {
  description = "Secondary availability zone — required by RDS subnet group"
  type        = string
  default     = "us-east-1b"
}
