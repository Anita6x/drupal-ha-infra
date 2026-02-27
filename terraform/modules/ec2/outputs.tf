output "instance_id" {
  description = "EC2 instance ID — useful for debugging in AWS console"
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance — use this to SSH in"
  value       = aws_instance.app.public_ip
}

output "public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.app.public_dns
}
