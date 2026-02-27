variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "environment" {
  description = "staging or dev"
  type        = string
}

variable "vpc_id" {
  description = "The VPC to create security groups inside"
  type        = string
}

variable "vpc_cidr" {
  description = "The VPC IP range — used to allow internal traffic"
  type        = string
}

variable "your_ip" {
  description = <<-EOT
    Your personal IP address for SSH access to EC2.
    Find it by visiting https://checkip.amazonaws.com
    Format: "YOUR.IP.ADDRESS.HERE/32"
    The /32 means just this one exact IP address.
  EOT
  type = string
}
