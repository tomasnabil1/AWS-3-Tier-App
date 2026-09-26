output "alb_dns_name" {

  value = aws_lb.main.dns_name
}

output "ec2_instance_ids" {
  value = [
    aws_instance.ec2-1.id,
    aws_instance.ec2-2.id
  ]

}
