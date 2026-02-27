output "db_endpoint" {
  description = <<-EOT
    The connection address for the database.
    Looks like: drupal-dev-mysql.abc123.us-east-1.rds.amazonaws.com
    EC2 uses this to connect to MySQL.
  EOT
  value     = aws_db_instance.mysql.endpoint
  sensitive = true
}

output "db_host" {
  description = "Just the hostname part of the endpoint (without the port)"
  value       = aws_db_instance.mysql.address
  sensitive   = true
}

output "db_port" {
  description = "MySQL port — always 3306"
  value       = aws_db_instance.mysql.port
}

output "db_name" {
  description = "Database name Drupal will connect to"
  value       = aws_db_instance.mysql.db_name
}

output "db_username" {
  description = "Database master username"
  value       = aws_db_instance.mysql.username
  sensitive   = true
}
