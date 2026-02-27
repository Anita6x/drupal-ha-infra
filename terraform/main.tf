terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Tell Terraform to use AWS in your chosen region.
# Credentials come from "aws configure" you ran earlier.
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

# ── STEP 1: VPC & NETWORKING ──────────────────
module "vpc" {
  source = "./modules/vpc"

  project_name          = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_cidr   = var.private_subnet_cidr
  private_subnet_cidr_b = var.private_subnet_cidr_b
  availability_zone_a   = var.availability_zone_a
  availability_zone_b   = var.availability_zone_b
}

#STEP 2 ✅ — SECURITY GROUPS
module "security_groups" {
  source = "./modules/security-groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = module.vpc.vpc_cidr
  your_ip      = var.your_ip
}

# STEP 3 ✅ — EC2 APP SERVERx
module "ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_groups.ec2_sg_id
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  key_name          = var.key_name

  db_endpoint = module.rds.db_endpoint
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

# STEP 4 ✅ — RDS DATABASE
module "rds" {
  source = "./modules/rds"

  project_name         = var.project_name
  environment          = var.environment
  db_subnet_group_name = module.vpc.db_subnet_group_name
  security_group_id    = module.security_groups.rds_sg_id
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_instance_class    = var.db_instance_class
}

# STEP 5 ✅ — LOAD BALANCER
module "alb" {
  source = "./modules/alb"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  public_subnet_id      = module.vpc.public_subnet_id
  public_subnet_b_id    = module.vpc.public_subnet_b_id
  alb_security_group_id = module.security_groups.alb_sg_id
  ec2_instance_id       = module.ec2.instance_id
}
