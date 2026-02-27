# ── ALB SECURITY GROUP ────────────────────────
# The Load Balancer is public-facing.
# We allow HTTP (port 80) from anyone on the internet.
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Allow HTTP traffic from the internet to the Load Balancer"
  vpc_id      = var.vpc_id

  # INBOUND — allow HTTP from anywhere
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # OUTBOUND — allow all outbound traffic
  # (ALB needs to forward traffic to EC2)
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}


# ── EC2 SECURITY GROUP ────────────────────────
# The app server is NOT public. Only two things
# can reach it:
# 1. The Load Balancer (port 80)
# 2. Your personal IP for SSH (port 22)
resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-${var.environment}-ec2-sg"
  description = "Allow HTTP from ALB and SSH from admin IP only"
  vpc_id      = var.vpc_id

  # INBOUND — HTTP from ALB only
  # Notice we reference the ALB security group, not 0.0.0.0/0
  # This means ONLY traffic coming from the ALB is allowed.
  # Direct internet access to EC2 is blocked.
  ingress {
    description     = "HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # INBOUND — SSH from your IP only
  # Your IP is 105.115.5.111 — hardcoded via variable.
  # /32 means this exact IP address and nothing else.
  ingress {
    description = "SSH from admin IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.your_ip]
  }

  # OUTBOUND — allow all outbound
  # EC2 needs to reach the internet to download
  # packages, talk to RDS, send logs etc.
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-sg"
  }
}


# ── RDS SECURITY GROUP ────────────────────────
# MySQL is the most locked down.
# ONLY the EC2 server can talk to it on port 3306.
# The internet cannot reach it at all.
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Allow MySQL from EC2 only"
  vpc_id      = var.vpc_id

  # INBOUND — MySQL from EC2 security group only
  # Again we reference a security group, not an IP.
  # This means only resources inside the EC2 security
  # group can connect — nobody else.
  ingress {
    description     = "MySQL from EC2 only"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  # OUTBOUND — allow all outbound
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  }
}
