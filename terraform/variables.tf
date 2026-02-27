variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Short project name — appears in every resource name"
  type        = string
  default     = "drupal"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "IP range for the entire VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "IP range for the public subnet (EC2 + Load Balancer)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "IP range for private subnet A (RDS lives here)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_b" {
  description = "IP range for private subnet B (required by RDS)"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone_a" {
  description = "Primary availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_b" {
  description = "Secondary availability zone (required by RDS)"
  type        = string
  default     = "us-east-1b"
}

variable "your_ip" {
  description = "Your personal IP for SSH access — find it at checkip.amazonaws.com"
  type        = string
}


variable "instance_type" {
  description = "EC2 instance size — t2.micro is free tier"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the EC2 key pair you created in AWS console"
  type        = string
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS AMI for us-east-1"
  type        = string
  default     = "ami-0261755bbcb8c4a84"
}

variable "db_name" {
  description = "Drupal database name"
  type        = string
  default     = "drupal"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "drupal"
}

variable "db_password" {
  description = "Database master password — never commit this to GitHub"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance size — db.t2.micro is free tier"
  type        = string
  default     = "db.t3.micro"
}
