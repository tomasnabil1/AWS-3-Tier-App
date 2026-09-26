## ALB DNS Name
output "alb_dns_name" {
  value       = module.compute.alb_dns_name
  description = "DNS name of the Application Load Balancer"

}

## EC2 instance IDs 

output "ec2_instace_ids" {
  value       = module.compute.ec2_instance_ids
  description = "IDs of the EC2 instances"

}


## RDS Endpoint
output "rds_endpoint" {
  value       = module.database.db_endpoint
  description = "Endpoint of the RDS database"

}

## RDS instance ID
output "db_instance_id" {
  value       = module.database.db_endpoint_id
  description = "ID of the RDS instance"


}
