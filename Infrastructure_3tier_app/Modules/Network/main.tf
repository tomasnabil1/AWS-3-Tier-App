## VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "${var.project_name}-vpc"     
    }  
}
## public subnet 1
resource "aws_subnet" "public1" {
   vpc_id                  = aws_vpc.main.id
   availability_zone       = "us-east-1a"
   cidr_block              = "10.0.1.0/24"
   map_public_ip_on_launch = true

   tags = {
        Name = "${var.project_name}-subnet"     
    }
}

## public subnet 2 
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true  

  tags = {
    Name = "${var.project_name}-subnet"
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

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.main.id
}

## route table association public subnet 2
resource "aws_route_table_association" "main2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.main.id
}