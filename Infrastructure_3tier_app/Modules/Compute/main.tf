## EC2-1 instances 
resource "aws_instance" "ec2-1" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_id
  subnet_id                   = var.private_subnet_ids[0]
  vpc_security_group_ids      = [var.ec2_sg_id]
  user_data_replace_on_change = true
  user_data                   = <<-EOF
#!/bin/bash 

 dnf install -y nginx 
 systemctl enable nginx 
 systemctl start nginx 
   echo "<h1>Hello from EC2-1</h1>" > /usr/share/nginx/html/index.html
EOF

  tags = {
    Name = "${var.project_name}-ec2-1"
  }
}

## EC2-2 instances 
resource "aws_instance" "ec2-2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_id
  subnet_id              = var.private_subnet_ids[1]
  vpc_security_group_ids = [var.ec2_sg_id]

  user_data_replace_on_change = true
  user_data                   = <<-EOF
  #!/bin/bash
  dnf install -y nginx
  systemctl enable nginx
  systemctl start nginx
  echo "<h1>Hello from EC2-2</h1>" > /usr/share/nginx/html/index.html
EOF
  tags = {
    Name = "${var.project_name}-ec2-2"
  }
}

## target group 

resource "aws_lb_target_group" "main" {

  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

}

## target group attachment for EC2_1

resource "aws_lb_target_group_attachment" "ec2_1" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.ec2-1.id
  port             = 80
}


## target group attachment for EC2_2
resource "aws_lb_target_group_attachment" "ec2_2" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.ec2-2.id
  port             = 80

}

## ALB (APPLICATION LOAD BALANCER)


resource "aws_lb" "main" {

  name               = "${var.project_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.project_name}-lb"
  }


}

resource "aws_lb_listener" "http" {
  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn

  }
}
