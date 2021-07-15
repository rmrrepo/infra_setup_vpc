provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_vpc"  "main"  {
    cidr_block = var.vpc_cidr

    tags = {
        Name    =   var.vpcname
    }
}

resource "aws_subnet" "main" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.vpc_cidr

    tags = {
        Name = ""
    } 
}
/*
resource "aws_instance" "app_server" {
  ami           = "ami-08d70e59c07c61a3a"
  instance_type = "t2.micro"

  tags = {
    Name = "vpc_app_server_instance"
  }
}
*/

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "main"
  }
}

resource "aws_eip" "lb" {
  instance = aws_instance.app_server.id
  vpc      = true
}

resource "aws_nat_gateway" "ng" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.gw]
}

