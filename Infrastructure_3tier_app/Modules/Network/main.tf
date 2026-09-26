## VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.project_name}-vpc"
  }
}
## public subnet 1 For ALB (Application Load Balancer)
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-subnet1"
  }
}

## public subnet 2 for ALB (Application Load Balancer)
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-subnet2"
  }

}

## internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

## route table 

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-route-table"
  }

}

## route table association public subnet 1

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.main.id
}

## route table association public subnet 2
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.main.id
}

## private subnet 1 for EC2 instances
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.3.0/24"
  tags = {
    Name = "${var.project_name}-subnet3"
  }

}


## private subnet 2 for EC2 instances
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.4.0/24"
  tags = {
    Name = "${var.project_name}-subnet4"
  }
}

## EIP (Elastic IP) for NAT Gateway

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}


## NAT Gateway
resource "aws_nat_gateway" "main" {

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
}

## private route table

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

## route table association private subnet 1

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

## route table association private subnet 2
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

## private DB subnet 1

resource "aws_subnet" "private_db1" {

  vpc_id            = aws_vpc.main.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.5.0/24"

  tags = {
    Name = "${var.project_name}-subnet5"
  }
}

## private DB subnet 2

resource "aws_subnet" "private_db2" {

  vpc_id            = aws_vpc.main.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.6.0/24"
  tags = {
    Name = "${var.project_name}-subnet6"
  }
}

## Private DB route table 

resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-private-db-route-table"
  }

}

## route table association private DB subnet 1 

resource "aws_route_table_association" "private_db1" {

  subnet_id      = aws_subnet.private_db1.id
  route_table_id = aws_route_table.private_db.id
}

## route table association private DB subnet 2

resource "aws_route_table_association" "private_db2" {

  subnet_id      = aws_subnet.private_db2.id
  route_table_id = aws_route_table.private_db.id
}

## DB subnet group

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.private_db1.id, aws_subnet.private_db2.id]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

## ALB security group

resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-lb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

## EC2 security group

resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## DB security group

resource "aws_security_group" "db_sg" {

  name        = "${var.project_name}-db-sg"
  description = "Security group for DB instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


