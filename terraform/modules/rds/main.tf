
# ── RDS PARAMETER GROUP ───────────────────────
# A parameter group is a collection of MySQL settings.
# We create our own so we can tune MySQL for Drupal.
# If we don't create one, AWS uses its default settings.
resource "aws_db_parameter_group" "mysql" {
  name        = "${var.project_name}-${var.environment}-mysql8"
  family      = "mysql8.0"
  description = "Custom MySQL 8.0 settings for Drupal"

  # Log slow queries — helpful for finding performance issues
  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  # Any query taking longer than 2 seconds is logged as slow
  parameter {
    name  = "long_query_time"
    value = "2"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-mysql8"
  }
}


# ── RDS MYSQL INSTANCE ────────────────────────
# The actual managed database.
# db.t2.micro = free tier eligible.
# AWS handles backups, patching, and availability.
resource "aws_db_instance" "mysql" {
  identifier     = "${var.project_name}-${var.environment}-mysql"
  engine         = "mysql"
  engine_version = var.mysql_version
  instance_class = var.db_instance_class

  # Storage — free tier allows up to 20GB
  allocated_storage = var.db_allocated_storage
  storage_type      = "gp2"
  storage_encrypted = false

  # Database credentials
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Networking — place in private subnets
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.security_group_id]

  # NOT publicly accessible — only EC2 can reach it
  publicly_accessible = false

  # Single AZ — Multi-AZ costs money and is not free tier
  multi_az = false

  # Parameter group with our custom MySQL settings
  parameter_group_name = aws_db_parameter_group.mysql.name

  # Backups — keep 7 days of automatic backups
  # This is free and gives you restore points
  backup_retention_period = 7
  backup_window           = "03:00-04:00"

  # Maintenance window — AWS applies patches here
  maintenance_window = "Mon:04:00-Mon:05:00"

  # Auto upgrade minor versions (e.g. 8.0.28 → 8.0.32)
  auto_minor_version_upgrade = true

  # When running terraform destroy, take a final snapshot
  # before deleting. Safety net in case you delete by accident.
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.project_name}-${var.environment}-final-snapshot"

  # Prevent accidental deletion via terraform destroy
  # Set to false when you actually want to destroy
  deletion_protection = false

  tags = {
    Name = "${var.project_name}-${var.environment}-mysql"
  }
}
