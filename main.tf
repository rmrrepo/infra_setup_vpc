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

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_public_cidr
    availability_zone = "us-west-2a"
    tags = {
        Name = "public_subnet"
    } 
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_private_cidr
    availability_zone = "us-west-2a"
    tags = {
        Name = "private_subnet"
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
    Name = "Demo-VPC-IGW"
  }
}

resource "aws_eip" "eip_nat" {
  #instance = aws_instance.app_server.id
  vpc      = true
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "ng" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "Demo VPN NAT"
  }

  depends_on = [aws_internet_gateway.gw]
}



resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ng.id
  }

  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "public_route_asso" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_route_asso" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
