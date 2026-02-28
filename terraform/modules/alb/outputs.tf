output "alb_dns_name" {
  description = <<-EOT
    The public URL of your Load Balancer.
    Paste this into your browser to visit your Drupal site.
    Looks like: drupal-dev-alb-123456.us-east-1.elb.amazonaws.com
  EOT
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ALB ARN — used internally by AWS"
  value       = aws_lb.main.arn
}

output "target_group_arn" {
  description = "Target group ARN — useful for adding more EC2 instances later"
  value       = aws_lb_target_group.drupal.arn

}

output "alb_arn_suffix" {
  description = "ALB ARN suffix for CloudWatch metrics"
  value       = aws_lb.main.arn_suffix
}

output "target_group_arn_suffix" {
  description = "Target group ARN suffix for CloudWatch metrics"
  value       = aws_lb_target_group.drupal.arn_suffix
}
