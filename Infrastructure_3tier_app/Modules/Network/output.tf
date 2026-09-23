output "vpc_id" {
  value   = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value   = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]
  description = "The IDs of the public subnets"
}
output "private_subnet_ids" {
    value = [
        aws_subnet.private1.id,
        aws_subnet.private2.id
    ]
     
    description = "The IDs of the private subnets"
}

output "private_db_subnet_ids" {
    value = [
        aws_subnet.private_db1.id,
        aws_subnet.private_db2.id
    ]
    description = "The IDs of the private DB subnets"
}

output "alb_sg_id" {
    value = aws_security_group.alb_sg.id
    description = "The ID of the ALB security group"
}

output "ec2_sg_id" {
    value = aws_security_group.ec2_sg.id
    description = "The ID of the EC2 security group"
}

output "db_sg_id" {
    value = aws_security_group.db_sg.id
    description = "The ID of the DB security group"
}
output "db_subnet_group_name" {
    value = aws_db_subnet_group.main.name
    description = "The name of the DB subnet group"
}
