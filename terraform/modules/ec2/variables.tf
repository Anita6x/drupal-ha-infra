variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "environment" {
  description = "dev or staging"
  type        = string
}

variable "vpc_id" {
  description = "VPC to launch the EC2 instance into"
  type        = string
}

variable "subnet_id" {
  description = "Public subnet to launch EC2 into"
  type        = string
}

variable "security_group_id" {
  description = "EC2 security group ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance size — t2.micro is free tier"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = <<-EOT
    The Amazon Machine Image — think of it as the
    operating system for your EC2 instance.
    We use Ubuntu 22.04 LTS in us-east-1.
    ami-0261755bbcb8c4a84 is the official Ubuntu 22.04 AMI.
  EOT
  type        = string
  default     = "ami-0261755bbcb8c4a84"
}

variable "key_name" {
  description = <<-EOT
    The name of the EC2 key pair for SSH access.
    You will create this in the AWS Console before running apply.
    We'll walk through that below.
  EOT
  type        = string
}

variable "db_endpoint" {
  description = "RDS endpoint passed to EC2 as an environment variable"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "drupal"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "drupal"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = ""
}
