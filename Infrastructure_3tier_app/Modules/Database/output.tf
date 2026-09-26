output "db_endpoint" {
  value       = aws_db_instance.main.endpoint
  description = "RDS database endpoint"
}

output "db_endpoint_id" {
  value       = aws_db_instance.main.id
  description = "RDS instance ID"
}
