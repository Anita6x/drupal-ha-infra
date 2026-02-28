output "sns_topic_arn" {
  description = "SNS topic ARN — used to send alert emails"
  value       = aws_sns_topic.alerts.arn
}

output "dashboard_url" {
  description = "Direct link to your CloudWatch dashboard"
  value       = "https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}
