## EC2-1 instances 
resource "aws_instance" "ec2-1" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_id
    subnet_id = var.private_subnet_ids[0]
    vpc_security_group_ids = [var.ec2_sg_id]
   tags = {
    Name = "${var.project_name}-ec2-1"
  }
}

## EC2-2 instances 
resource "aws_instance" "ec2-2" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_id
  subnet_id = var.private_subnet_ids[1]
  vpc_security_group_ids = [var.ec2_sg_id]

  
  tags = {
    Name = "${var.project_name}-ec2-2"
  }
}