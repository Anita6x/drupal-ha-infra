# ── THE VPC ───────────────────────────────────
# Your private network in AWS. Everything we
# build lives inside here.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}


# ── INTERNET GATEWAY ──────────────────────────
# The door between your VPC and the internet.
# Without this, nothing inside can reach outside.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}


# ── PUBLIC SUBNET ─────────────────────────────
# EC2 and Load Balancer live here.
# map_public_ip_on_launch gives EC2 a public IP
# automatically so we can reach it from outside.
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet"
  }
}

# Second public subnet in AZ-B (required by ALB)
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet-b"
  }
}

# Associate second public subnet with public route table
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}
# ── PRIVATE SUBNET A ──────────────────────────
# RDS MySQL lives here.
# No public IPs. No internet route.
# Only EC2 can talk to it via security groups.
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone_a

  tags = {
    Name = "${var.project_name}-${var.environment}-private-subnet-a"
  }
}


# ── PRIVATE SUBNET B ──────────────────────────
# AWS requires RDS subnet groups to span at
# least 2 AZs. Nothing is deployed here —
# it just satisfies that requirement.
resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_b
  availability_zone = var.availability_zone_b

  tags = {
    Name = "${var.project_name}-${var.environment}-private-subnet-b"
  }
}


# ── PUBLIC ROUTE TABLE ────────────────────────
# Tells traffic in the public subnet:
# "anything going to the internet → use the IGW"
# This is what makes the subnet truly "public".
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

# Connect the public subnet to the public route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# ── PRIVATE ROUTE TABLE ───────────────────────
# No internet route added here — intentional!
# Traffic in private subnets stays inside the VPC.
# MySQL should never be reachable from outside.
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}


# ── RDS SUBNET GROUP ──────────────────────────
# RDS needs this to know which subnets it can
# use. We give it both private subnets (2 AZs)
# even though MySQL only runs in one of them.
resource "aws_db_subnet_group" "main" {
  name = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}
