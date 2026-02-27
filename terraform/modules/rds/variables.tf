variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "environment" {
  description = "dev or staging"
  type        = string
}

variable "db_subnet_group_name" {
  description = "The subnet group RDS will deploy into"
  type        = string
}

variable "security_group_id" {
  description = "RDS security group ID"
  type        = string
}

variable "db_name" {
  description = "Name of the database Drupal will use"
  type        = string
  default     = "drupal"
}

variable "db_username" {
  description = "Master database username"
  type        = string
  default     = "drupal"
}

variable "db_password" {
  description = "Master database password — never commit to GitHub"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance size — db.t3.micro is free tier eligible"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Storage in GB — free tier allows up to 20GB"
  type        = number
  default     = 20
}

variable "mysql_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}
